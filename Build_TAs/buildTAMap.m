function buildTAMap

code = sprintf('var TAMap = new Map();\n');
buildHelpDeskData();

end

function buildHelpDeskData()

[~,~,r] = xlsread('Name_List_Fall_15.xlsx');
TANames = r(2:end,1);
helpDeskTimes = r(2:end,9);

[~,~,funFacts] = xlsread('Name_List_Fall_15.xlsx','Sheet2');
funFacts = funFacts(:,2:end);
nameCol = find(strcmp(funFacts(1,:),'Who are you?'));
funFactNames = funFacts(:,nameCol);
makeUpYourOwnCol = find(strcmp(funFacts(1,:),'Make up your own!'));
funFacts = [funFacts(:,1:nameCol-1) funFacts(:,nameCol+1:end)];
funFacts = [funFacts(:,1:makeUpYourOwnCol-1) funFacts(:,makeUpYourOwnCol+1:end)];

notFound = '[[''Favorite Matlab Function'',''strtok''],[''Favorite Hashtag'',''#strtok''],[''Favorite Homework Problem'',''The one with strtok''],[''Hobbies'',''I like long walks on the strtok, strtokking in the woods, and just really a good strtok whenever I get the chance.''],[''Most embarrassing story from middle school'',''One time I was walking down the hall and accidently spilled my strtok all over the floor''],[''Team sum(mask) or team length(vec(mask))'',''There is no other function but strtok''],[''Pro switch or anti switch'',''Pro strtok''],[''Most embarrassing recitation story'',''One time I was teaching and almost forgot to strtok. So embarrassing.''],[''Which team are you on?'',''The only team. Jacob. JK strtok''],[''Favorite quote'',''\"To strtok, or not to strtok, that is the question. Wait that isn\''t a question, always strtok\"''],[''Advise to your 5th grade self'',''Remember to floss your strtok every day.''],[''I cry while grading tests when...'',''there isn\''t any strtok. So I add it myself.''],[''Favorite Song'',''\"Sugar pie honey strtok\"''],[''I am the best in the world at:'',''I am an olympic strtoker. My strtoks are heard around the world.''],[''Mac (*barf*) or PC?'',''Any computer with a strtok.''],[''This one time at band camp...'',''Why was I at bandcamp when I could have been strtoking.''],[''When I was 5 years old, I wanted to be a...'',''Astronaut. Just kidding, there are no strtoks in space.''],[''Advise to yourself while you were taking the class'',''Make sure you include a strtok on every line.''],[''Best Joke'',''Why did the chicken cross the road? To get to the other strtok'']]';

allCode = '';
days = struct('M','monday','T','tuesday','W','wednesday','R','thursday','F','friday');

for i = 1:length(TANames)
    if i==40
        test = true;
    end
    TAHelpDeskTimes = helpDeskTimes{i};
    
    if ~isnan(TAHelpDeskTimes)
        allTimes = strsplit(TAHelpDeskTimes,',');
        helpDeskStr = '[';
        for j = 1:length(allTimes)
            currTime = allTimes{j};
            currTime(currTime==' ') = '';
            day = currTime(1);
            day = days.(day);
            time = currTime(2:end);
            timeStr = sprintf('[''%s'',''%s'']',day,time);
            
            helpDeskStr = [helpDeskStr timeStr ','];
        end
        helpDeskStr(end) = ']';
    else
        helpDeskStr = '[]';
    end
    
    %     str1 = sprintf('[''%s'',''%s'']',days{day},times{time1});
    %     str2 = sprintf('[''%s'',''%s'']',days{day2},times{time2});
    %     helpDeskString = sprintf('[%s,%s]',str1,str2);
    %
    if i==24
        flag = true;
    end
    taRow = strcmp(funFactNames,strtrim(TANames{i}));
    if any(taRow)
        TAFunFacts = funFacts(taRow,:);
        
        funFactsStr = '[';
        for k = 1:length(TAFunFacts)
            if ~isnan(TAFunFacts{k})
                factString = '[''%s'',''%s'']';
                factString = sprintf(factString, funFacts{1,k}, strrep(strrep(TAFunFacts{k},'''','\'''),'"','\"'));
                
                funFactsStr = [funFactsStr factString ','];
            end
        end
        funFactsStr(end) = ']';
        
    else
        funFactsStr = notFound;
    end
    
    %     favorites = '[[''Favorite Matlab Function'',''isequal()''],[''Favorite Homework Problem'',''sixDegreesOfWaldo''],[''Story'',''This is an example of a really long answer that takes up multiple lines in the slide in menu'']]';
    %
    code = sprintf('TAMap.set(''%s'',[%s,%s]);',strrep(TANames{i},'''',''),helpDeskStr,funFactsStr);
    %
    allCode = [allCode code sprintf('\n')];
end

fh = fopen('script.txt','w');
fprintf(fh,'%s',allCode);
fclose(fh);

end