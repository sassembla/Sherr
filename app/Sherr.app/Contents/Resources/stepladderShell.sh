basepath=$1
targetShellName=$2


# goto Sherr.app folder
cd ${basepath}

# goto above Sherr.app
cd ../

# run shell which located at Sherr.app/
path=${basepath}/${targetShellName}

sh ${path}