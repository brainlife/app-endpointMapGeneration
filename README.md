[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/soichih/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.194-blue.svg)](https://https://doi.org/10.25663/brainlife.app.194)

# app-roi2roitracking
This app will generate streamline endpoint density maps for all tracts in an input [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b).  The user can specify what sort of decay/smoothing algorithm can be used (or whether one should be used at all).  

### Authors
- [Daniel Bullock](https://github.com/DanNBullock) (dnbulloc@iu.edu)

### Contributors
- [Soichi Hayashi](https://github.com/soichih) (hayashis@iu.edu)

### Project Director
- [Franco Pestilli](https://github.com/francopestilli) (franpest@indiana.edu)


### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NIMH-T32-5T32MH103213-05](https://img.shields.io/badge/NIMH_T32-5T32MH103213--05-blue.svg)](https://projectreporter.nih.gov/project_info_description.cfm?aid=9725739)

## Running the App 

### Inputs
- a [track/tck](https://brainlife.io/datatypes/5907d922436ee50ffde9c549) input - this is the tractogram to wich the associated [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) corresponds.
- a [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) - Each of the identified anatomical structures (presumptave tracts) in the input [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) will have its endpoint mapping generated
- a [freesurfer](https://brainlife.io/datatypes/58cb22c8e13a50849b25882e) output
- [decayFunc](https://github.com/DanNBullock/wma_tools/blob/903a2af76578d6a8931fa4c931682993b11bd40e/Stream_Tools/bsc_classifiedStreamEndpointCortex.m#L32) parameter input - this parameter selection determines the decay function which will be used to apply smoothing to the streamline endpoint mask.  It can be one of the following:
	- uniform/box: no distance loss until threshold, then zero
        - gaussian:  applies a gaussian smoothing kernel
        - exact:  only counts exact endpoint voxel
- [decayRadiusThresh](https://github.com/DanNBullock/wma_tools/blob/903a2af76578d6a8931fa4c931682993b11bd40e/Stream_Tools/bsc_classifiedStreamEndpointCortex.m#L42) this parameter sets the **radius** of the smoothing kernel that will be applied to the streamline endpoint mask.  

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/brainlife.app.194](https://https://doi.org/10.25663/brainlife.app.194) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
	"track": "path/to/tck/associated/with/classification/tck.tck",
	"classification": "path/to/classification.mat",
	"freesurfer":"path/to/this/subjects/freesurfer/dir/",
	"decayFunc":"exact",
	"decayRadiusThresh":"3"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input

tck, fs & classification example data needed

```


3. Launch the App by executing `main`

```bash
./main
```

## Output

- [ROIS](https://brainlife.io/datatypes/5be9ea0315a8683a39a1ebd9) - a directory containing the streamline endpoint mappings for each item in the input [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b) [2 per "tract"]

Note that each input "tract" results in two endpoint mapping nifti outputs.  RAS corresponds to the right/anterior/superior-most cluster of endpoints (as determined by the primary route of travel of the tract).  LPI corresponds the left/posterior/inferior-most cluster of endpoints (as determined by the primary route of travel of the tract).  The naming of endpoint clusters (beyond the RAS/LIP designation) is carried over from items in the [White Matter Classification (WMC) structure](https://brainlife.io/datatype/5cc1d64c44947d8aea6b2d8b).

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - VISTASOFT: https://github.com/vistalab/vistasoft/
  - ENCODE: https://github.com/brain-life/encode
  - SPM 8 or 12: https://www.fil.ion.ucl.ac.uk/spm/software/spm8/
  - WMA: https://github.com/DanNBullock/wma_tools/tree/master
  - Freesurfer: https://hub.docker.com/r/brainlife/freesurfer/tags/6.0.0
  - mrtrix: https://hub.docker.com/r/brainlife/mrtrix_on_mcr/tags/1.0
  - jsonlab: https://github.com/fangq/jsonlab.git
