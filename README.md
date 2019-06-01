[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/soichih/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.194-blue.svg)](https://https://doi.org/10.25663/brainlife.app.194)

# app-roi2roitracking
This app will generate endpoint maps for all tracts in an input classification structure.  User can specify what sort of decay/smoothing algorithm can be used (or none).  

### Authors
- Dan Bullock (dnbulloc@iu.edu)

### Contributors
- Soichi Hayashi (hayashi@iu.edu)

### Contributors
- Franco Pestilli (franpest@iu.edu)


### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running the App 

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

This function outputs a directory full of niftis, corresponding to the two sets of endpoint mappings associated with each given tract.  RAS corresponds to the right/anterior/superior-most cluster of endpoints (as determined by the primary route of travel of the tract.  LAP corresponds to the same for the other cluster.  Current naming conventions are based upon classification input.

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - VISTASOFT: https://github.com/vistalab/vistasoft/
  - ENCODE: https://github.com/brain-life/encode
  - SPM 8 or 12: https://www.fil.ion.ucl.ac.uk/spm/software/spm8/
  - WMA: https://github.com/brain-life/wma
  - Freesurfer: https://hub.docker.com/r/brainlife/freesurfer/tags/6.0.0
  - mrtrix: https://hub.docker.com/r/brainlife/mrtrix_on_mcr/tags/1.0
  - jsonlab: https://github.com/fangq/jsonlab.git
