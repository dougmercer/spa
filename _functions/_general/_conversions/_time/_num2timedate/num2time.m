function [t] = num2time(n)
	n=n*24;
	h=floor(n);
	n=60*(n-h);
	m=floor(n);
	n=60*(n-m);
	s=ceil(n);
	t=strcat(num2str(h,'%02.0f'), ':', num2str(m,'%02.0f'), ':', num2str(s,'%02.0f'));
end