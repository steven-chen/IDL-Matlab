function timer_callback(obj,event,ptime)
   disp('timer callback');
   ptime_str = sprintf('%d��%d��%d��%dʱ%d��%d��',fix(clock));
   set(ptime,'string',ptime_str,'position',[-10,-10]);
   drawnow;
 