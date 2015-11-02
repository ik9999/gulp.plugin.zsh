function $$gulp_completion () {
    if [ -f "gulpfile.js" ]; then
        files=("$(realpath gulpfile.js)")
        requireDirVar="$(grep -Eo "[var|let].*require\(['\"]require\-dir['\"]\);$" gulpfile.js | grep -Eo " [^ =]*" | head -1| grep -Eo "[^ ]*")"
        if [ ! -z "$requireDirVar" ]; then
            requiredDirs="$(grep -Eo "requireDir\(['\"][^'\"]*" gulpfile.js | grep -Eo "['\"].*" | grep -Eo "['\"].*" | sed s/"['\"]"//g)"  
            requiredDirsArray=("${(f)requiredDirs}")
            requiredFilesStr="$(find $requiredDirsArray -maxdepth 1 -name '*.js' -exec readlink -f {} \;)"
            requiredFilesArray=("${(f)requiredFilesStr}")
            files=($files $requiredFilesArray)
        fi
        filesUnique=(${(u)files[@]})
        tasks="$(grep -Eo "gulp.task\(['\"]([^'\"]*)['\"]," $filesUnique | grep -Eo "['\"]([^'\"]*)['\"]" | sed s/"['\"]"//g | sort)"
        completions=(${=tasks})
        compadd -- $completions
    fi
}

compdef $$gulp_completion gulp

