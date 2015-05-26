function [ ] = quickset( where, v, varargin )
%migrated
out=getappdata(0,where);

if ~isempty(varargin)
    out=rsetfield(out, v, varargin);
else
    out=v;
end
setappdata(0,where, out);
end

