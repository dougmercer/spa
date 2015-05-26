function [ feasibleProjects ] = isfeasmatch( i )
%i:= ith student
students=quickget('students');
projects=quickget('projects');
nProj=length(projects);

candoMaj=false(1,nProj);
candoSec=false(1,nProj);
candoNDA=false(1,nProj);
candoIPA=false(1,nProj);
for j=1:length(projects)
    %check for major feasibility
    candoMaj(j) = any(myismember(students(i).majors, projects(j).majors));
    %check for section feasibility
    candoSec(j)=any(myismember(students(i).sections, projects(j).section));
    %check for nda feasibility  
    candoNDA(j)= students(i).nda || ~(projects(j).nda);
    %check for ipa feasibility
    candoIPA(j) = students(i).ipa || ~(projects(j).ipa);
end
%combine all feasibilities into one
feasibleProjects=candoMaj & candoSec & candoNDA & candoIPA;