# MRS Data Processing and Analysis Pipeline

This repository contains MATLAB scripts and functions for processing, analyzing, and performing tissue correction on MEGA-PRESS magnetic resonance spectroscopy (MRS) data.

The pipeline supports two studies:

* **Audio Study (ARHL):** Processing and analysis of MEGA-PRESS data from the audio study.
* **PMDD Study:** Processing and analysis of MEGA-PRESS data from the PMDD study.

The pipeline uses FID-A for MRS data loading and preprocessing, LCModel for metabolite quantification, and Gannet for tissue segmentation and correction.

---

## Table of Contents

1. [Prerequisites and Software Installation](#1-prerequisites-and-software-installation)
2. [MATLAB Path Configuration](#2-matlab-path-configuration)
3. [Data Loading and Preprocessing](#3-data-loading-and-preprocessing)
4. [LCModel Configuration](#4-lcmodel-configuration)
5. [LCModel Analysis](#5-lcmodel-analysis)
6. [Creating MATLAB Tables](#6-creating-matlab-tables)
7. [Gannet Tissue Segmentation](#7-gannet-tissue-segmentation)
8. [Metabolite Tissue Correction](#8-metabolite-tissue-correction)
9. [Output Summary](#9-output-summary)

---

## 1. Prerequisites and Software Installation

### Required Software

The following software packages are required to run the pipeline:

| Software | Purpose                                      |
| -------- | -------------------------------------------- |
| MATLAB   | Data processing and analysis                 |
| FID-A    | MRS data loading and preprocessing           |
| Gannet   | Tissue segmentation and correction           |
| SPM12    | Image segmentation and tissue classification |
| LCModel  | Metabolite quantification                    |

Download or obtain the required software from the appropriate repositories or official sources.

### Cloning GitHub Repositories

In a Linux terminal, navigate to the directory where you want to store the required software and custom scripts.

For example:

```bash
mkdir -p /path/to/folder
cd /path/to/folder
```

Clone the FID-A repository:

```bash
git clone https://github.com/CIC-methods/FID-A.git
```

Download or clone Gannet and SPM12 according to their respective distribution instructions.

**Recommended directory structure:**

Keep the required software packages and custom MATLAB scripts together in a common directory to simplify path management.

For example:

```text
/path/to/folder/
├── FID-A/
├── Gannet/
├── spm12/
├── custom_scripts/
└── new_lcmctrl_sh/
```

The directory names above are examples. Adjust them to match your actual installation.

---

## 2. MATLAB Path Configuration

Before running the pipeline, MATLAB must be able to locate the required software packages and custom functions.

Add the main directory and all subdirectories to the MATLAB path:

```matlab
addpath(genpath('/path/to/folder'))
```

Replace `/path/to/folder` with the directory containing the required software and custom scripts.

This command recursively adds the directory and its subdirectories to the MATLAB search path.

Run this command at the beginning of your MATLAB session, or save the path configuration using MATLAB's `savepath` function if you want it to persist between sessions.

---

## 3. Data Loading and Preprocessing

The pipeline provides three options for loading and preprocessing MRS data, depending on whether you are working with an individual scan, a single patient, or a section of an entire study.

### 3.1. Load and Preprocess a Single Scan

To load and preprocess a single Siemens DICOM MRS scan, use:

```matlab
[raw, info] = io_loadspec_dicom_siemens('/path/to/scan');
```

**Inputs:**

* `/path/to/scan`: Path to the directory containing the scan data.

**Outputs:**

* `raw`: Loaded and preprocessed MRS data.
* `info`: Associated scan information and metadata.

### 3.2. Load and Preprocess a Single Patient

To load and preprocess all relevant MEGA-PRESS acquisitions for an individual patient, use:

```matlab
[diff1, edit_off1, water1, ...
 diff2, edit_off2, water2] = ...
    io_loadspec_dicom_MEGA_1('/path/to/directory');
```

The function processes data from two regions of interest (ROIs).

The outputs are organized as follows:

| Output      | Description                      |
| ----------- | -------------------------------- |
| `diff1`     | Difference spectrum for Region 1 |
| `edit_off1` | Edit-off spectrum for Region 1   |
| `water1`    | Water reference for Region 1     |
| `diff2`     | Difference spectrum for Region 2 |
| `edit_off2` | Edit-off spectrum for Region 2   |
| `water2`    | Water reference for Region 2     |

The numbers 1 and 2 denote the two different regions.

### 3.3. Load and Preprocess a Section of an Entire Study

To load and preprocess a group of patients from a study, use:

```matlab
data = io_loadData('/path/to/parentfolder');
```

The function loads the data from the specified parent directory and organizes the results into a cell array.

The output, `data`, is a `y × 7` cell array, where `y` represents the number of patients processed.

The columns are organized as follows:

| Column | Contents                      |
| ------ | ----------------------------- |
| 1      | Difference spectrum, Region 1 |
| 2      | Edit-off spectrum, Region 1   |
| 3      | Water reference, Region 1     |
| 4      | Difference spectrum, Region 2 |
| 5      | Edit-off spectrum, Region 2   |
| 6      | Water reference, Region 2     |
| 7      | Patient ID                    |

**Important:** This function requires manual intervention. During execution, MATLAB prompts the user to manually align the edit-on and edit-off spectra.

You must remain present during this step to complete the alignment for each patient.

Once the function has finished processing the dataset, save the resulting data.

### 3.4. Save the Preprocessed Data

To save the processed data as a MATLAB file, use:

```matlab
save('/path/to/folder/data_name.mat');
```

Replace `data_name` with the desired filename.

The saved file can subsequently be loaded for LCModel analysis.

---

## 4. LCModel Configuration

Before running LCModel analysis, several configuration files and MATLAB scripts must be updated to reflect your local directory structure.

### 4.1. Update LCModel Control Files

Navigate to the `new_lcmctrl_sh` directory.

Open the following control files:

```text
tmp_pt_MEGA_3T_diff.control
tmp_pt_MEGA_3T_off.control
```

Locate the `FILBAS` parameter in each file.

Update the paths as follows:

| Control file                  | Required basis file                |
| ----------------------------- | ---------------------------------- |
| `tmp_pt_MEGA_3T_diff.control` | `jn_megapress_capetown_diff.basis` |
| `tmp_pt_MEGA_3T_off.control`  | `jn_megapress_capetown_off.basis`  |

Ensure that each `FILBAS` entry points to the correct basis file on your system.

### 4.2. Update the LCModel MATLAB Scripts

Open the following MATLAB scripts:

```text
lcm_audio_updated.m
lcm_PMDD_updated.m
```

Both scripts require the following configuration changes.

#### Output Directory

Locate the variable named `path`.

Update it to the directory where you want the LCModel output files to be saved.

For example:

```matlab
path = '/path/to/lcmodel/output';
```

Use the appropriate output directory for your study.

#### LCModel Control Script Path

Depending on your directory structure and naming conventions, you may need to update the variables `cmd_1`, `cmd_2`, and any subsequent command variables.

These variables must point to the correct location of the LCModel control scripts within `new_lcmctrl_sh`.

Ensure that the paths retain the appropriate script names and directory structure, such as:

```text
/path/to/new_lcmctrl_sh/createLCMcontrol.sh
```

Update the paths in both `lcm_audio_updated.m` and `lcm_PMDD_updated.m` as necessary.

Verify that the referenced shell scripts exist and are accessible before proceeding.

---

## 5. LCModel Analysis

Once the configuration is complete and the preprocessed data has been saved, you can begin LCModel analysis.

### 5.1. Load the Preprocessed Data

In MATLAB, load the previously saved dataset:

```matlab
load('/path/to/folder/data_name.mat');
```

Ensure that the loaded variables correspond to the dataset you intend to analyze.

### 5.2. Audio Study (ARHL)

Run the Audio Study LCModel analysis function:

```matlab
lcm_audio_updated(data_name);
```

Replace `data_name` with the name of the variable containing the preprocessed dataset.

After LCModel analysis is complete, organize the generated CSV files:

```matlab
organizecsv('/path/to/folder');
```

The function organizes the LCModel CSV outputs into the specified directory.

### 5.3. PMDD Study

Run the PMDD LCModel analysis function:

```matlab
lcm_PMDD_updated(data_name);
```

After the analysis is complete, organize the generated CSV files using:

```matlab
organizecsv_pmdd('/path/to/folder');
```

Use the appropriate output directory for the PMDD dataset.

---

## 6. Creating MATLAB Tables

After organizing the LCModel CSV files, convert the outputs into MATLAB tables for subsequent analysis.

Run the following function:

```matlab
Study_x_region_y_editoff = createtable('/path/to/folder');
```

For difference spectra, use:

```matlab
Study_x_region_y_diff = createtable('/path/to/folder');
```

Replace the example variable names with the appropriate study, region, and acquisition labels.

The `createtable` function generates a MATLAB table and saves the resulting data as a `.mat` file.

These tables will be used as inputs for the metabolite tissue correction functions described in Section 8.

---

## 7. Gannet Tissue Segmentation

Gannet is used to perform tissue segmentation and estimate the proportions of white matter (WM), grey matter (GM), and cerebrospinal fluid (CSF) within the MRS voxels. To use these function ensure that your MRI data is .nii and not .dicom.

The Gannet functions process the study data and generate outputs in the corresponding patient folders.

### 7.1. Audio Study (ARHL)

Run:

```matlab
gannet_path('/path/to/folder');
```

Example:

```matlab
gannet_path('/zpool/data/studies/ARHL');
```

### 7.2. PMDD Study

Run:

```matlab
gannet_path_PMDD('/path/to/folder');
```

Replace the path with the parent directory containing the PMDD patient folders.

### 7.3. Organize Gannet Outputs

The Gannet functions generate output files within the individual patient folders.

To combine these outputs into a single directory for subsequent analysis:

1. Open the custom MATLAB function named `csv`.
2. Locate the variable `newFolder`.
3. Update `newFolder` to the desired output directory.
4. Run the function:

```matlab
csv('/path/to/folder');
```

This step groups the Gannet-generated CSV files into a common directory.

The resulting directory will be used as the `csv` input for metabolite tissue correction.

---

## 8. Metabolite Tissue Correction

After LCModel quantification and Gannet tissue segmentation are complete, apply tissue correction to the metabolite concentrations.

The correction functions require two inputs:

| Input   | Description                                                        |
| ------- | ------------------------------------------------------------------ |
| `table` | MATLAB table containing the LCModel output, saved as a `.mat` file |
| `csv`   | Directory containing the organized Gannet CSV outputs              |

### 8.1. Audio Study (ARHL)

Run the following function:

```matlab
[mega1, edit1, mega2, edit2] = ...
    metabolite_correction(table, csv);
```

**Inputs:**

* `table`: LCModel output table generated in Section 6.
* `csv`: Directory containing the organized Gannet CSV files generated in Section 7.

Example:

```matlab
[mega1, edit1, mega2, edit2] = ...
    metabolite_correction(ARHL, ...
    '/zpool/data/matthew/ARHL_CSV');
```

In this example, `ARHL` represents the loaded MATLAB variable containing the LCModel output table.

#### Outputs

| Output  | Description                                                                                 |
| ------- | ------------------------------------------------------------------------------------------- |
| `mega1` | Tissue-corrected metabolite concentrations from the MEGA-PRESS difference spectra, Region 1 |
| `edit1` | Tissue-corrected metabolite concentrations from the MEGA-PRESS edit-off spectra, Region 1   |
| `mega2` | Tissue-corrected metabolite concentrations from the MEGA-PRESS difference spectra, Region 2 |
| `edit2` | Tissue-corrected metabolite concentrations from the MEGA-PRESS edit-off spectra, Region 2   |

The `mega` outputs correspond to the difference spectra, while the `edit` outputs correspond to the edit-off spectra.

The numerical suffixes identify the two regions of interest.

### 8.2. PMDD Study

For the PMDD study, use:

```matlab
[mega1A, mega2A, edit1A, edit2A, ...
 mega1B, mega2B, edit1B, edit2B] = ...
    metabolite_correction_PMDD(table, csv);
```

**Inputs:**

* `table`: LCModel output table for the PMDD study.
* `csv`: Directory containing the organized Gannet CSV outputs for the PMDD study.

The function returns tissue-corrected metabolite concentrations for the two study groups or conditions, labeled A and B, across the two regions and both acquisition types.

The exact mapping of A and B to study groups or conditions should follow the organization used in the PMDD dataset and the implementation of `metabolite_correction_PMDD.m`.

---

## 9. Output Summary

The complete pipeline consists of the following stages:

| Stage | Processing step                | Main output                                     |
| ----- | ------------------------------ | ----------------------------------------------- |
| 1     | Data loading and preprocessing | Preprocessed MRS data                           |
| 2     | LCModel analysis               | Metabolite quantification CSV files             |
| 3     | CSV organization               | Grouped LCModel outputs                         |
| 4     | MATLAB table creation          | `.mat` files containing LCModel tables          |
| 5     | Gannet tissue segmentation     | Tissue segmentation and water reference outputs |
| 6     | Gannet CSV organization        | Consolidated tissue segmentation CSV files      |
| 7     | Metabolite tissue correction   | Tissue-corrected metabolite concentrations      |

The final outputs consist of tissue-corrected metabolite concentrations for the MEGA-PRESS difference and edit-off spectra across the two regions of interest.

These outputs can be used for subsequent statistical analysis and comparisons within the respective studies.

---

## Notes and Troubleshooting

* **Paths:** Replace all example paths with the actual paths on your system. Use absolute paths when configuring external software and shell scripts.
* **MATLAB variables:** Ensure that the variable passed to the LCModel functions matches the name of the loaded preprocessed dataset.
* **Manual alignment:** The `io_loadData` function requires user interaction for spectral alignment. Do not leave the function unattended during this stage.
* **LCModel configuration:** Verify that the basis files, control files, and shell scripts are correctly configured before starting the analysis.
* **Gannet outputs:** Run the Gannet processing functions before executing the `csv` grouping function and metabolite correction functions.
* **Study-specific processing:** Use the Audio Study functions for ARHL data and the PMDD-specific functions for PMDD data.
