#!/bin/bash

robot="booster_k1"
output_dir="/home/nao/Documents/GMR/output/${robot}"
num_cpus=22
# Clean output directory if it exists
if [ -d "$output_dir" ]; then
    echo "Cleaning existing output directory..."
    sudo rm -rf "$output_dir"
fi

# Create fresh output directory with proper permissions
mkdir -p "$output_dir/training_data"
chmod -R 755 "$output_dir"

# Initialize conda in this shell session
eval "$(conda shell.bash hook)"

#delete old env
conda env remove -n gmr -y

# create conda env
conda create -n gmr python=3.10 -y

# Activate the environment
conda activate gmr

# install GMR
pip install -e .

# to resolve some possible rendering issues
conda install -c conda-forge libstdcxx-ng -y

# Activate the environment directly instead of using conda run
python scripts/smplx_to_robot_dataset.py --src_folder "/home/nao/Documents/GMR/assets/body_models/AMASS_-x_npz" --tgt_folder "$output_dir/training_data/" --robot "$robot" --num_cpus "$num_cpus"


