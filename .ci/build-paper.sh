#!/bin/bash -x

if git diff --name-only $TRAVIS_COMMIT_RANGE | grep 'paper/'
then
  # Install tectonic using conda
  wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;

  bash miniconda.sh -b -p $HOME/miniconda
  export PATH="$HOME/miniconda/bin:$PATH"

  # Conda Python
  hash -r
  conda config --set always_yes yes --set changeps1 no
  conda update -q conda
  conda info -a
  conda create --yes -n paper
  source activate paper
  conda install -c conda-forge -c pkgw-forge tectonic
  
  # wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh;
  # bash miniconda.sh -b -p $HOME/miniconda
  # export PATH="$HOME/miniconda/bin:$PATH"
  # hash -r
  # conda config --set always_yes yes --set changeps1 no
  # conda update -q conda
  # conda info -a
  # conda install -c conda-forge texlive-core 

  # Build the paper using tectonic
  tectonic beane_paper.tex --print
  
  # cd paper
  # pdflatex beane_paper.tex
  # bibtex beane_paper
  # bibtex beane_paper
  # pdflatex beane_paper.tex
  # pdflatex beane_paper.tex
  
  # Build dark mode
  # pdflatex beane_paper-dark.tex
  # bibtex beane_paper-dark
  # bibtex beane_paper-dark
  # pdflatex beane_paper-dark.tex
  # pdflatex beane_paper-dark.tex

  # Force push the paper to GitHub
  cd $TRAVIS_BUILD_DIR
  git checkout --orphan $TRAVIS_BRANCH-pdf
  git rm -rf .
  git add -f paper/beane_paper.pdf
  git add -f paper/beane_paper-dark.pdf
  git -c user.name='travis' -c user.email='travis' commit -m "building the paper"
  git push -q -f https://$GITHUB_USER:$GITHUB_API_KEY@github.com/$TRAVIS_REPO_SLUG $TRAVIS_BRANCH-pdf
fi
