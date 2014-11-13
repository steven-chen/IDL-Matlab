function timer_callback(obj,event,ptime)
   disp('timer callback');
   ptime_str = sprintf('%d年%d月%d日%d时%d分%d秒',fix(clock));
   set(ptime,'string',ptime_str,'position',[-10,-10]);
   drawnow;
 