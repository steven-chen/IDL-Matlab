function hidematlab()
%HIDEMATLAB Hide the main Matlab desktop window (HACK)

dtWin = desktopwindow();
if ~isempty(dtWin)
    dtWin.setVisible(0);
end