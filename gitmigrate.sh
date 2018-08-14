#!/bin/bash
#wscnbackend project
project_name=(ivankagateway ivankadelegate ivankadedicate ivankauser ivankacontent ivankanginy ivankapush ivankacomment ivankaprovision forexdata ivankafinfo ivankabridge apiconf ivankastore ivankaudata ivankasearch ivankamigrate marketdata ivankacooperation ivankaoauth ivankarealtime ivankatoutiao)

#wscnfrontend project
#project_name=(juicy weex ivanka-trump ivanka-mobile wscn-chart goldtoutiao ivanka-premium-marticle wx-mina)

source_repo=git@***:wscnbackend
target_repo=git@***:wscnbackend
rootdir=`dirname $0`
cachedir=$rootdir/gitmigratecache

for project in ${project_name[@]}; do
    git clone $source_repo/$project $cachedir
    pushd $cachedir
    for r in `git branch -r|grep -v 'master\|HEAD'`; do
        git branch ${r#*/} --track $r
    done
    git push --all $target_repo/$project.git
    git push --tags $target_repo/$project.git
    popd
    rm -rf $cachedir
done

