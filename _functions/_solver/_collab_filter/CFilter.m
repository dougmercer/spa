function [ r ] = CFilter( v, r )
%NEW_CF Summary of this function goes here
%   Detailed explanation goes here

%get appdata
students=getappdata(0, 'students');
projects=getappdata(0, 'projects');
pref=getappdata(0, 'pref');

%set useful parameters
nStudents = length(students);
nProjects=length(projects);
vbar = (pref.solver.maxvotes + 1)/2; %assume average value

%initialize similary weight matrix
w=zeros(nStudents,nStudents);

%Populate similarity weight matrix 
for i = 1:nStudents
    for j = i + 1:nStudents
        matched_projects = find(isnan(v(i,:)) == 0 & isnan(v(j, :)) == 0);
        if length(matched_projects) >= pref.solver.minmatchproj
            shifted_i = v(i, matched_projects) - vbar;  %student i vals - avg
            shifted_j = v(j, matched_projects) - vbar;  %student j vals - avg
            num = sum(shifted_i.*shifted_j);
            denom = (sum(shifted_i.^2) * sum(shifted_j.^2))^.5;
            w(i,j) = num/denom;
        end
    end
end
%upper-triangular to full matrix
w = w + w';% since there's no diagonal, we can just add the transpose to w

%Select the k-nearest neighbors
for i = 1:nStudents
    if nnz(w(i, :) > 0) < pref.solver.maxneighbors
        students(i).neighbors = find(w(i,:) > 0);
    else
        students(i).neighbors = kmax(w(i,:), pref.solver.maxneighbors);
    end 
end

%Add k-nearest neighbors' recommendations
for i=1:nStudents
    K = students(i).neighbors;
    iChosen = ~isnan(v(i,:));
    kChosen = zeros(1, nProjects);    
    kChosen(sum(~isnan(v(K, :)) ,1) > 0) = 1;
    iFeas = isfeasmatch( i );%logical array of feasible projects
    %find projects chosen by k, feasible for i; not already preferred by i
    kProj = find((iFeas - iChosen) & kChosen); 
    for j = kProj
        %determine Kp subset of K that voted for item j
        Kp = K(v(K, j) > 0);
        %compute how much the k neighborhood recommends the project
        val = vbar + (1/sum(w(i, Kp))) * w(i,Kp) * (v(Kp,j) - vbar);
        scale = (1/pref.solver.maxvotes); %scale to make these vals < 1
        r(i, j) = val * scale; %place scaled value into r
    end
end

end

