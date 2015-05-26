function S = rsetfield(S, V, field)
	if length(field) > 1
        if ~isfield(S,field{1})
            S.(field{1}) = struct;%if creating new field at depth
        end
		S.(field{1}) = rsetfield(S.(field{1}), V, field(2:end));
	else
		S.(field{1}) = V;
	end
end