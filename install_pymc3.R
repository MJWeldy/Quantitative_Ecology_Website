condaPath = try(reticulate::conda_binary()) #error is OK
if (is.null(condaPath) | class(condaPath) == "try-error") {
  ## install miniconda in default location if possible
  condaInstall = try(reticulate::install_miniconda())
  condaPath = try(reticulate::miniconda_path())
  ## if install still fails install miniconda in C:\miniconda
  if(class(condaInstall) == "try-error") {
    condaPath = file.path("/", "miniconda")
    reticulate::install_miniconda(path = condaPath,
                                  force = TRUE)}
  reticulate::miniconda_update(path = condaPath) #update new install
  newCondaInstall = TRUE  ## flag to update env var if needed
} else {
  reticulate::miniconda_update() ## update existing conda
  newCondaInstall = FALSE
  ### this environment is added automatically by install_miniconda()
  reticulate::conda_create(envname = "r-pymc3") ## add environment
}

#### STEP 3: RESTART R WITH CONDA ENVIRONMENT HINT
#### GIVEN IN EDITED .Rprofile FILE
## capture environment variable for inclusion in .Rprofile
newProfileLines = c() ## initialize config lines for .Rprofile
if(newCondaInstall) {  ## help R find new install location
  newProfileLines = c(
    newProfileLines,
    paste0("Sys.setenv(RETICULATE_MINICONDA_PATH = '",
           condaPath, "')")
  )
  rProfilePath = file.path("~", ".Rprofile")
  profileLines = c()  ## init blank lines
  if (file.exists(rProfilePath)) {
    ## is there a .RProfile file?
    profileLines = readLines(rProfilePath)# get rProfile
  }
  ## add new line to top of file
  profileLines = c(newProfileLines, profileLines)
  writeLines(profileLines, rProfilePath)
  .rs.restartR()  ## run & wait for R session to resume 
  ## (at least 15 seconds) before continuing
}

#### STEP 4:  Update "r-reticulate" CONDA ENVIRONMENT
####          FOR TENSORFLOW
## Install the specific versions of modules
## for the TensorFlow installation via CONDA.
## this line takes a few minutes to execute
reticulate::conda_create(envname = "r-pymc3") 
reticulate::conda_install(envname = "r-pymc3",
                          packages =
                            c(
                              "python<3.8",
                              "arviz", 
                              "matplotlib",
                              "numpy",
                              "pandas",
                              "pymc3<3.10",
                              #"python=3.8.5",
                              #"pymc3==3.11.0"
                              # "numpy>=1.16",
                              # #"theano-pymc==1.1.2"
                              # "python=3.7.10",
                               "m2w64-toolchain",
                              # "arviz==0.6.1",
                              # "pymc3==3.8",
                              # "scipy>=0.19",
                              "theano==1.0.5",
                              "pip"
                            ))

reticulate::conda_create(envname = "r-pymc3") 
reticulate::conda_install(envname = "r-pymc3",
                          packages =
                            c(
                              "python=3.8",
                              #"arviz>=0.9",
                              "arviz<=0.10",
                              "theano-pymc==1.0.11",
                              "numpy>=1.13",
                              "scipy>=0.18",
                              "pandas>=0.18",
                              "patsy>=0.5",
                              "fastprogress>=0.2",
                              "h5py>=2.7",
                              "typing-extensions>=3.7",
                              "python-graphviz",
                              "ipython>=7.16",
                              "nbsphinx>=0.4",
                              "numpydoc>=0.9",
                              "pre-commit>=2.8.0",
                              "pytest-cov>=2.5",
                              "pytest>=3.0",
                              "recommonmark>=0.4",
                              "sphinx-autobuild>=0.7",
                              "sphinx>=1.5",
                              "watermark",
                              "mkl-service",
                              "dill",
                              "m2w64-toolchain",
                              "libblas=*=*mkl",
                              "pymc3=3.10.0"
                            ))
