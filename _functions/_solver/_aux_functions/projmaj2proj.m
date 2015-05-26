function [ majnum ] = projmaj2proj( node_num, nStudents, nMajors )
shift_node = node_num - nStudents - 1;
majnum = mod(shift_node, nMajors);
if majnum == 0
    majnum = nMajors;
end
end

