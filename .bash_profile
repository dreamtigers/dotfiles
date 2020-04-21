# Load ~/.profile regardless of shell version
if [ -e "$HOME"/.profile ] ; then
    . "$HOME"/.profile
fi

# If ~/.bashrc exists, source that too
if [ -f "$HOME"/.bashrc ] ; then
    . "$HOME"/.bashrc
fi