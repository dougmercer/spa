function [ ] = create_testmat( nstudents, nprojects )
[students, projects, sections, majors] = generate_data(nstudents,nprojects);
clear nstudents;
clear nprojects;
save('test_cathy.mat');
end

