import os
import anndata
from argparse import ArgumentParser
import numpy as np
import optuna
import pandas as pd
import torch

from scquint.dimensionality_reduction import Dataset, VAE, UnsupervisedTrainer, Posterior
from scquint.utils import filter_min_cells_per_feature, group_normalize

input_path = "output/quantification/introns-shared-acceptor/adata_annotated.h5ad"
adata = anndata.read_h5ad(input_path)
print(adata.shape)
adata = filter_min_cells_per_feature(adata, 100)
print(adata.shape)
feature_addition = group_normalize(adata.X.sum(axis=0), adata.var.cluster, smooth=False).A1.ravel()
dataset = Dataset(adata)
print(dataset.X.shape)

n_epochs=300
use_cuda=True

early_stopping = dict(
    early_stopping_metric='reconstruction_error',
    on="validation_set",
    patience=10,
    threshold=1,
    reduce_lr_on_plateau=True,
    lr_patience=5,
    lr_factor= 0.5,
)


def main():
    study_name = "vae_100"

    def objective(trial):
        print("trial.number: ", trial.number)
        out_path = f"{study_name}_trial_{trial.number}"
        os.makedirs(out_path)
        print("out_path", out_path)

        lr = 1e-2
        n_epochs_kl_warmup = 20

        model_kwargs = {}
        model_kwargs["n_latent"] = trial.suggest_int("n_latent", 10, 40)
        model_kwargs["dropout_rate"] = trial.suggest_uniform("dropout_rate", 0.1, 0.5)
        model_kwargs["n_hidden"] = trial.suggest_categorical("n_hidden", [128, 256])
        model_kwargs["linearly_decoded"] = trial.suggest_categorical("linearly_decoded", [True, False])
        if model_kwargs["linearly_decoded"]:
            model_kwargs["regularization_gaussian_std"] = trial.suggest_loguniform("regularization_gaussian_std", 1.0, 100.0)
        else:
            model_kwargs["n_layers"] = trial.suggest_int("n_layers", 1, 3)
            if model_kwargs["n_layers"] > 2 or model_kwargs["n_hidden"] > 128:
                lr = 1e-3

        print("lr: ", lr)

        print(model_kwargs)
        vae = VAE(
            dataset.n_genes, dataset.n_introns, dataset.n_clusters, dataset.intron_clusters,
            input_transform="frequency-smoothed", feature_addition=feature_addition,
            use_cuda=True, **model_kwargs
        )

        trainer = UnsupervisedTrainer(
            vae, dataset, train_size=0.8, test_size=0.1, use_cuda=use_cuda, frequency=5,
            n_epochs_kl_warmup=n_epochs_kl_warmup, early_stopping_kwargs=early_stopping)

        trainer.train(n_epochs=n_epochs, lr=lr)
        torch.save(trainer.model.state_dict(), os.path.join(out_path, 'vae.pkl'))

        elbo = trainer.history["reconstruction_error_test_set"]
        print(elbo)
        print(trainer.history)
        best_elbo = np.nanmin(elbo)
        print("best_elbo: ", best_elbo)

        vae.eval()
        posterior = Posterior(vae, dataset, use_cuda=use_cuda, data_loader_kwargs={'batch_size': 128})
        latent_spl_vae = posterior.get_latent(sample=False)[0]
        np.savetxt(os.path.join(out_path, 'latent.txt'), latent_spl_vae)

        return best_elbo

    study = optuna.create_study(
        study_name=study_name,
        storage=f'sqlite:///{study_name}.sqlite3',
        load_if_exists=True,
        direction="minimize",
    )
    study.optimize(objective, n_trials=40)
    study.trials_dataframe().to_csv(f"{study_name}_trials_dataframe.txt", "\t")
    print(study.best_params)


if __name__ == "__main__":
    main()
