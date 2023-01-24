#!/bin/bash

NON_VERSIONED_PATH="C:/Users/Usuario/Desktop/link"
REPO_PATH="C:/Users/Usuario/Desktop/QLAB/GitHub/Corruption_Paper"

ln -s "${NON_VERSIONED_PATH}/input"       "${REPO_PATH}/input"
ln -s "${NON_VERSIONED_PATH}/output/data" "${REPO_PATH}/output/data"
ln -s "${NON_VERSIONED_PATH}/tmp"         "${REPO_PATH}/tmp"