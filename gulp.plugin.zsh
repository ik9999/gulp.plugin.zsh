function $$gulp_completion () {
    if [[ -f "gulpfile.js" || -f "gulpfile.babel.js" ]]; then
        gulpFileName="gulpfile.js"
        if [ -f "gulpfile.babel.js" ]; then
            gulpFileName="gulpfile.babel.js"
        fi
        files=("$(readlink -f $gulpFileName)")
        requireDirVar="$(grep -Eo "[var|let].*require\(['\"]require\-dir['\"]\)" $gulpFileName 2>/dev/null | grep -Eo " [^ =]*" | head -1| grep -Eo "[^ ]*")"
        if [[ -z  "$requireDirVar"  ]] then
            requireDirVar="$(grep -Eo "import.*from[^'\"]*['\"]require\-dir['\"]" $gulpFileName 2>/dev/null | grep -Eo "import *[^ ]* *from" | grep -Eo "import *[^ ]*" | grep -Eo "[^ ]*" | tail -1)"
        fi
        if [ ! -z "$requireDirVar" ]; then
            requiredDirs="$(grep -Eo "requireDir\(['\"][^'\"]*" $gulpFileName 2>/dev/null | grep -Eo "['\"].*" | grep -Eo "['\"].*" | sed s/"['\"]"//g)"  
            requiredDirsArray=("${(f)requiredDirs}")
            requiredFilesStr="$(find $requiredDirsArray -maxdepth 1 -name '*.js' -exec readlink -f {} \;)"
            requiredFilesArray=("${(f)requiredFilesStr}")
            files=($files $requiredFilesArray)
        fi
        filesUnique=(${(u)files[@]})
        tasks="$(grep -Eo "gulp.task\(['\"]([^'\"]*)['\"]," $filesUnique 2>/dev/null | grep -Eo "['\"]([^'\"]*)['\"]" | sed s/"['\"]"//g | sort)"
        completions=(${=tasks})
        compadd -- $completions
    fi
}

compdef $$gulp_completion gulp

