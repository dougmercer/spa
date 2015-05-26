function [secdat,majdat ] = refreshlist(tabledata,type)
%REFRESHLIST Summary of this function goes here
%   Detailed explanation goes here

[m, ~] = size(tabledata);
fails_list = cell(0, 0);
failm_list = cell(0, 0);
fails_inds = cell(0, 0);
failm_inds = cell(0, 0);

if strcmp(type, 'projects')
    secInd = 4;
    majInd = 5;
else
    secInd = 9;
    majInd = 5;
end

for i = 1:m
    %begin sections
    sections=strsplit(tabledata{i,secInd},',');
    %sections = mystrsplit(tabledata{i, secInd}, ',');
    for j = 1:length(sections)
        [~, flag] = findTag(sections{j}, 'sections');
        if flag
            fails_list{length(fails_list) + 1, 1} = sections{j};
            fails_inds{length(fails_inds) + 1, 1} = num2str(tabledata{i, 1});
        end
    end
    %end sections
    %check majors
    majors=strsplit(tabledata{i,majInd},',');
    %majors = mystrsplit(tabledata{i, majInd}, ',');
    for j = 1:length(majors)
        [~, flag] = findTag(majors{j}, 'majors');
        if flag
            failm_list{length(failm_list) + 1, 1} = majors{j};
            failm_inds{length(failm_inds) + 1, 1} = num2str(tabledata{i, 1});
        end
    end
    %end check majors
end
secdat = count_fails(fails_list);
majdat = count_fails(failm_list);
quickset('missingMajors', failm_list);
quickset('missingSections', fails_list);
quickset('missingMajors_inds', failm_inds');
quickset('missingSections_inds', fails_inds');
end

