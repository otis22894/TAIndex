function buildTAs

[~,~,r] = xlsread('Name_List_Fall_15.xlsx');
[rows,~] = size(r);

cssFh = fopen('style.css','w');
htmlFh = fopen('code.html','w');

template = fileread('TA_Template.txt');

positionBadge = '<div class="positionBadge">%s</div>';
elementBeforePositionBadge = '<div class="circlePicContainer" id="~fullLower~Pic"></div>';

for j = 2:rows
   currTA = template;
   if j==25 
    flag = true;
   end
   if ~isnan(r{j,8})
       loc = strfind(currTA,elementBeforePositionBadge) + length(elementBeforePositionBadge);
       currTA = [currTA(1:loc) sprintf('\t\t') sprintf(positionBadge,r{j,8}) currTA(loc+1:end)];
   end
   
   nameLoc = strfind(currTA,'~Name~');
   currTA = [currTA(1:nameLoc-1) r{j,1} currTA(nameLoc+6:end)];
   
   nameLoc = strfind(currTA,'~classInfo~');
   currTA = [currTA(1:nameLoc-1) r{j,3} currTA(nameLoc+11:end)];

   TAName = r{j,1};
   fullLowerLoc = strfind(currTA,'~fullLower~');
   currTA = [currTA(1:fullLowerLoc-1) lower(strrep(TAName(TAName~=' '),'''','')) currTA(fullLowerLoc+11:end)];
   
   sectionLoc = strfind(currTA,'~Section~');
   currTA = [currTA(1:sectionLoc-1) r{j,2} currTA(sectionLoc+9:end)];
   
   sectionLoc = strfind(currTA,'~recLocation~');
   currTA = [currTA(1:sectionLoc-1) r{j,6} currTA(sectionLoc+13:end)];
   
   sectionLoc = strfind(currTA,'~recTime~');
   currTA = [currTA(1:sectionLoc-1) r{j,7} currTA(sectionLoc+9:end)];
   
   [firstName, ~] = strtok(r{j,1});
   firstNameLoc = strfind(currTA,'~First~');
   currTA = [currTA(1:firstNameLoc-1) firstName currTA(firstNameLoc+7:end)];
   
   emailLocs = [1];
   while ~isempty(emailLocs)
       emailLocs = strfind(currTA,'~Email~');
       currTA = [currTA(1:emailLocs(1)-1) r{j,10} currTA(emailLocs(1)+7:end)];
       emailLocs(1) = [];
   end
   
   fprintf(cssFh,'#%sPic { \n\tbackground-image: url("TA_Pics/%s");\n}\n\n',strrep(lower(TAName(TAName~=' ')),'''',''),r{j,4});
   
   fprintf(htmlFh,'%s\n',currTA);
end

end