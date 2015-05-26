function [students, projects, sections, majors] = generate_data(n_students,n_projects)
n_types = 4;
cdf = generate_type_cdf(n_types);
majors = {'ie', 'cs', 'ee', 'me'};
sections = {'ie480', 'cmpsc483', 'ee403', 'me441'};


students(n_students).type = NaN; %initialize students
projects(n_projects).type = NaN; %initialze projects
for i = 1:n_students
    %hidden stuff
    students(i).type = choose(cdf);
    students(i).in_out = in_or_out_cdf();
    students(i).npref = num_prefs();
    s = sections{students(i).type};
    pos_sec = setdiff(sections, s);
    secs = randsample(pos_sec, randi(4)-1);
    %end hidden stuff
    students(i).id = randid;
    students(i).access = randaccess;
    students(i).first = randname(9);
    students(i).last = randname(9);
    students(i).ipa = randbool;
    students(i).nda = randbool;
    students(i).intent = randbool;
    students(i).time = 736000+rand;
    students(i).majors = {majors{students(i).type}};
    if isempty(secs)
        students(i).sections = {s};
    else
        students(i).sections = [secs, s];
    end
    students(i).preferences =[];
end
for i = 1:n_projects
    %hidden stuff
    projects(i).type = choose(cdf);
    m = majors{projects(i).type};
    pos_maj = setdiff(majors, m);
    majs = randsample(pos_maj, randi(4)-1);
    lb = randi(3);
    ub = max(lb, lb + randi(5-lb));
    %end hidden stuff
    projects(i).title = randname(10);
    projects(i).sponsor = randname(10);
    projects(i).section = {sections{projects(i).type}};
    if isempty(majs)
        projects(i).majors = {m};
    else
        projects(i).majors = [majs, m];
    end
    projects(i).nda = randbool;
    projects(i).ipa = randbool;
    projects(i).lb = lb;
    projects(i).ub = ub;
    for m=majors
        projects(i).majbounds.(m{1}).lb = 0;
        projects(i).majbounds.(m{1}).ub = 0;
    end
    for m = projects(i).majors
        if randbool
            projects(i).majbounds.(m{1}).ub = randi(5);
        end
    end
end
for i = 1:n_students
    [in_list, out_list] = get_lists(students(i), projects);
    for j = 1:students(i).npref
        if choose(students(i).in_out) == 1 %in-type
            if ~isempty(in_list)     %if there is an in-type project left
                n = length(in_list);
                choice = choose(1/n:1/n:1);
                students(i).preferences = [students(i).preferences, in_list(choice)];
                in_list(choice) = [];
            elseif ~isempty(out_list) %no in_type projects left
                n = length(out_list);
                choice = choose(1/n:1/n:1);
                students(i).preferences = [students(i).preferences, out_list(choice)];
                out_list(choice) = [];
            %else: no preference will be added
            end
        else
            if ~isempty(out_list) %if there is an out-of type project left
                n = length(out_list);
                choice = choose(1/n:1/n:1);
                students(i).preferences = [students(i).preferences, out_list(choice)];
                out_list(choice) = [];
            elseif ~isempty(in_list) %no out projects left
                n = length(in_list);
                choice = choose(1/n:1/n:1);
                students(i).preferences = [students(i).preferences, in_list(choice)];
                in_list(choice) = [];
            %else: no preference will be added
            end
        end
    end
end

for s = sections
    real_sections.(s{1}).aliases = s;
end
sections = real_sections;
k = 1;
for m = majors
    real_majors.(m{1}).number = k;
    real_majors.(m{1}).aliases = m;
    k= k+1;
end
majors = real_majors;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                         Auxilliary Functions                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cdf] = generate_type_cdf(n_types)
pmf = rand(1, n_types);
pmf = pmf/sum(pmf);
cdf = zeros(1, n_types);
for i = 1:n_types
    cdf(i) = sum(pmf(1,1:i));
end

function [npref] = num_prefs()
min_pref = 5;
max_pref = 10;
npref = min_pref + round((max_pref-min_pref)*rand(1));

function [cdf] = in_or_out_cdf()
%Generate a cdf modelling chance that student 
%chooses project in his type or out of type
min_chance = 2/3;
cdf(1) = min_chance + (1-min_chance)*rand(1);
cdf(2) = 1;

