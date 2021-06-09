APP_VERSION=`xmllint --xpath '/*[local-name()="project"]/*[local-name()="version"]/text()' $POM_FILE`
APP_VERSION=`echo "${APP_VERSION}" | sed -e "s/-SNAPSHOT//"`

if [[ "$CI_COMMIT_BRANCH" == "hotfix" &&  "$APP_VERSION" == *0 ]]; then 
    echo "First commit on the hotfix branch, the version is actually .1"
    APP_VERSION=`echo "${APP_VERSION}" | sed -e "s/\.0/.1/"`
fi
echo "$APP_VERSION version in $CI_COMMIT_BRANCH  branch"

echo "export APP_VERSION=$APP_VERSION" > $VARIABLES_FILE
echo "export NEW_TAG=$APP_VERSION" >> $VARIABLES_FILE
if [[ ${CI_COMMIT_TITLE} =~ (([A-Z]+-[0-9]+)) ]]; then 
    export TICKET_ID=${BASH_REMATCH[1]}; 
else 
    export TICKET_ID="UNKNOWN"; 
fi
echo "export TICKET_ID=${TICKET_ID}" >> $VARIABLES_FILE
echo "export CHANGE_ID=${CI_PROJECT_NAME}-${APP_VERSION}" >> $VARIABLES_FILE


