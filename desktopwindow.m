function out = desktopwindow()
%DESKTOPWINDOW Find the main Matlab desktop window (HACK)

wins = java.awt.Window.getOwnerlessWindows();
out = [];
for i = 1:numel(wins)
    if isa(wins(i), 'com.mathworks.mde.desk.MLMainFrame')
        out = wins(i);
        return;
    end
end