function [h,hist_xvals,n]=mchist(x,varargin,sign)
%mrc
x0 = x(isfinite(x));
[n hist_xvals] = hist(x0,varargin);
if sign==1
h = bar(hist_xvals,n/sum(n));%%%
else h = bar(hist_xvals,-n/sum(n));%%%  remove sum(n)
end
