function [ out ] = quickget( where, varargin )
out=getappdata(0,where); 
for i=1:length(varargin)
    if ~isfield(out,varargin{i})
        out.(varargin{i})=struct;
    end
    out=out.(varargin{i});
end
end

