<h1 align="center">Generate tract endpoint maps</h1>

<p align="center">
  Streamline endpoint density maps, two per tract, for every tract in a white matter classification, masked to FreeSurfer grey matter.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.194"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.194-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> **This branch, `1.0`, is the brainlife.io App Generate tract endpoint maps** ([doi:10.25663/brainlife.app.194](https://doi.org/10.25663/brainlife.app.194)). The other Apps in this repository are listed under **Versions on brainlife.io** below.

## At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Generates streamline endpoint density maps for every tract in a white matter classification (wmc), with exact, box or Gaussian smoothing of endpoints, masked to FreeSurfer grey matter.**

Builds a grey matter mask from the FreeSurfer output and, for each classified tract, counts streamline endpoints per voxel, optionally spreading each endpoint with a box or Gaussian kernel of the given diameter, and writes the maps as NIfTI ROIs. Use it to see where tracts terminate in cortex or to make endpoint-based ROIs. The tck must be the tractogram the classification was computed on.

| | |
|---|---|
| **Inputs** | `neuro/track/tck` · `neuro/wmc` · `neuro/freesurfer` |
| **Outputs** | `neuro/rois` |
| **Container** | `brainlife/freesurfer_on_mcr:6.0.0` |
| **Resources** | 8 CPUs · 4 h walltime |
| **Requires** | `FREESURFER_LICENSE` |
| **Run it** | [doi.org/10.25663/brainlife.app.194](https://doi.org/10.25663/brainlife.app.194) |

#### Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `track` | `neuro/track/tck` | yes | Whole-brain tractogram the classification indexes into. Must be the tractogram used to generate the wmc classification. |
| `classification` | `neuro/wmc` | yes | White matter classification (wmc) assigning streamlines to tracts. |
| `freesurfer` | `neuro/freesurfer` | yes | FreeSurfer output used to build the grey matter mask. |

#### Outputs

| Output | Datatype | Description |
|---|---|---|
| `rois` | `neuro/rois` | Endpoint density maps, one NIfTI per tract and endpoint group. |

<details>
<summary><b>Parameters</b> (2)</summary>

| Parameter | Type | Default | Description |
|---|---|---|---|
| `decayFunc` | enum |  | How endpoints are turned into density: exact endpoint voxels only, box (every voxel within the threshold distance counts as an endpoint) or Gaussian smoothing. Options: `exact`, `box`, `gaussian`. |
| `decayRadiusThresh` | number | `1` | Odd integer values only, larger than 0. Defines the kernel to be used if either no decay or gaussian decay is selected. Defines *diameter* (not radius, hence odd) of smoothing kernel Ignored in the case of exact endpoints. |

</details>

<!-- brainlife-app:end -->

## Versions on brainlife.io

| Version | Branch | Run it | Status |
|---|---|---|---|
| **Generate tract endpoint maps** (this branch) | [`1.0`](https://github.com/brainlife/app-endpointMapGeneration/tree/1.0) | [doi:10.25663/brainlife.app.194](https://doi.org/10.25663/brainlife.app.194) | current |
| Generate tract endpoint maps (takes the older `neuro/wmc-deprecated` classification) | [`master`](https://github.com/brainlife/app-endpointMapGeneration/tree/master) | [doi:10.25663/brainlife.app.182](https://doi.org/10.25663/brainlife.app.182) | deprecated |

## How it works

1. A grey matter mask is built from the FreeSurfer `aparc+aseg` with `mri_binarize --gm` (FreeSurfer 6.0.0).
2. For each tract in the [White Matter Classification (WMC)](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b), the streamline endpoints are counted per voxel with [`bsc_classifiedStreamEndpointCortex`](https://github.com/DanNBullock/wma_tools/blob/903a2af76578d6a8931fa4c931682993b11bd40e/Stream_Tools/bsc_classifiedStreamEndpointCortex.m) from [wma_tools](https://github.com/DanNBullock/wma_tools) (compiled MATLAB). The decay function [`decayFunc`](https://github.com/DanNBullock/wma_tools/blob/903a2af76578d6a8931fa4c931682993b11bd40e/Stream_Tools/bsc_classifiedStreamEndpointCortex.m#L32) controls how each endpoint is spread:
   - `exact`: only the exact endpoint voxel is counted;
   - `box` (no decay): every voxel within the threshold distance counts as though it held the endpoint;
   - `gaussian`: each endpoint is spread with a Gaussian smoothing kernel.
3. [`decayRadiusThresh`](https://github.com/DanNBullock/wma_tools/blob/903a2af76578d6a8931fa4c931682993b11bd40e/Stream_Tools/bsc_classifiedStreamEndpointCortex.m#L42) sets the size of the box or Gaussian kernel. It is the kernel *diameter*, so use odd integers larger than 0; it is ignored for `exact`.

## Running the App

### On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.194](https://doi.org/10.25663/brainlife.app.194) and choose:

- a [`neuro/track/tck`](https://brainlife.io/datatypes/5907d922436ee50ffde9c549) tractogram: the one the classification was computed on;
- a [White Matter Classification (WMC)](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b): each tract in it gets its endpoint maps;
- a [FreeSurfer](https://brainlife.io/datatypes/58cb22c8e13a50849b25882e) output of the same subject.

Pick the decay function and kernel size and press **Execute**. The maps are archived to your project as a `neuro/rois` dataset tagged `tractEndpointDensity`.

### Locally

You need [Singularity/Apptainer](https://apptainer.org/), [`jq`](https://jqlang.github.io/jq/) and a [FreeSurfer license](https://surfer.nmr.mgh.harvard.edu/registration.html). The endpoint mapping is compiled MATLAB and runs in the `brainlife/mcr:neurodebian1604-r2017a` container, so MATLAB is not needed.

1. Clone this repository and check out the App's branch: `git checkout 1.0`.
2. Create `config.json` with the paths to your inputs and the options you want:

   ```json
   {
       "track": "/input/track/track.tck",
       "classification": "/input/wmc/classification.mat",
       "tracts": "/input/wmc/tracts",
       "freesurfer": "/input/freesurfer/output",
       "decayFunc": "gaussian",
       "decayRadiusThresh": 5
   }
   ```

3. Export your FreeSurfer license and run the App:

   ```bash
   export FREESURFER_LICENSE="$(cat ~/freesurfer/license.txt)"
   ./main
   ```

## Outputs

A [`neuro/rois`](https://brainlife.io/datatypes/5be9ea0315a8683a39a1ebd9) directory with the endpoint density maps as NIfTI files, two per tract in the classification:

- **RAS**: the right/anterior/superior-most cluster of endpoints, as determined by the tract's primary direction of travel;
- **LPI**: the left/posterior/inferior-most cluster of endpoints.

The rest of each file name is carried over from the tract names in the classification.

## Troubleshooting

- **`Please set FREESURFER_LICENSE in .bashrc`**: export your FreeSurfer license as `FREESURFER_LICENSE` before running `./main`.
- **Maps look wrong or empty**: the `.tck` must be the tractogram the classification indexes into.

## Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Generate tract endpoint maps. brainlife.io App. [doi:10.25663/brainlife.app.194](https://doi.org/10.25663/brainlife.app.194)
- Fischl. FreeSurfer. *NeuroImage* 62:774-781 (2012). [doi:10.1016/j.neuroimage.2012.01.021](https://doi.org/10.1016/j.neuroimage.2012.01.021)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## Authors

- Franco Pestilli (project director)
- [Daniel Bullock](https://github.com/DanNBullock)

**Contributors:** [Soichi Hayashi](https://github.com/soichih)

## Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## License

[MIT](LICENSE). The compiled code also includes [vistasoft](https://github.com/vistalab/vistasoft), [encode](https://github.com/brainlife/encode), [jsonlab](https://github.com/fangq/jsonlab) and [wma_tools](https://github.com/DanNBullock/wma_tools), each under its own license; FreeSurfer is distributed under its own [license](https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense).
