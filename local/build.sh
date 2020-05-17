#!/bin/sh
####################################################################
#
# Script to build dast automation utilities without docker dependency.
# The DAST_ROOT variable needs to be set.

# Author: srivastv
#
####################################################################

# verify DAST_ROOT location
if [ -z "$DAST_ROOT" ];
then
    echo "Please set DAST_ROOT (dir where dast scripts should be installed)"
    exit 1
fi

if [[ ! -d "$DAST_ROOT" ]];
then
    echo "DAST_ROOT ($DAST_ROOT) does not exist"
    exit 1
fi


rm -rf $DAST_ROOT/*

# install dependencies
cwd=$(pwd)
cd $DAST_ROOT

#install ZAP
echo "Installing ZAP"
rm -rf ZAP && mkdir ZAP && cd ZAP && curl -s https://raw.githubusercontent.com/zaproxy/zap-admin/master/ZapVersions.xml | xmlstarlet sel -t -v //url | grep -i Linux | wget -nv --content-disposition -i - -O - | tar zxv && cp -R ZAP*/* . && rm -rf ZAP* && curl -s -L https://bitbucket.org/meszarv/webswing/downloads/webswing-2.5.10.zip > webswing.zip && unzip webswing.zip && rm -f webswing.zip && mv webswing-* webswing && rm -rf webswing/demo/ && touch AcceptedLicense

echo "Installing python APIs"
mkdir $DAST_ROOT/temp
cp -r $cwd/dependencies/python-owasp-zap-v2.4-0.0.16.tar.gz $DAST_ROOT/temp/
tar -xvf $DAST_ROOT/temp/python-owasp-zap-v2.4-0.0.16.tar.gz -C $DAST_ROOT/temp/
cp -r $DAST_ROOT/temp/python-owasp-zap-v2.4-0.0.16/src/zapv2 $DAST_ROOT/
rm -rf $DAST_ROOT/temp

echo "Installing scripts"
cp -r $cwd/policies $DAST_ROOT/
cp $cwd/zap-api-scan.py $DAST_ROOT/
cp $cwd/zap-baseline.py $DAST_ROOT/
cp $cwd/zap-full-scan.py $DAST_ROOT/
cp $cwd/zap-webswing.sh $DAST_ROOT/
cp $cwd/zap-x.sh $DAST_ROOT/
cp $cwd/zap_common.py $DAST_ROOT/
cp $cwd/webswing.config $DAST_ROOT/
cp -r $cwd/scripts $DAST_ROOT/


echo "Build Successful"

