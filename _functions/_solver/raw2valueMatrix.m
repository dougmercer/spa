function [ valueMatrix ] = raw2valueMatrix( )

%get app data
students=quickget('students');
nStudents=length(students);
nProjects=length(quickget('projects'));
maxVotes=quickget('pref','solver','maxvotes');

valueMatrix=NaN(nStudents, nProjects);
for i=1:nStudents
    k=maxVotes;
    feasProjs=isfeasmatch(i);
    for j=students(i).preferences
        if j<=nProjects %make sure student's preference is less than the total number of projects
            if feasProjs(j) %make sure student preference is feasible, otherwise set preference to NaN
                score=1+(maxVotes-1)/log(maxVotes)*log(k);
                valueMatrix(i,j)=score;
                k=k-1;
            end
        end
    end
end
end