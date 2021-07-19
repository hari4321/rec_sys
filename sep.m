% 100,000 ratings (1-5) from 943 users on 1682 movies.
test_rat_=importdata('u.data');
test_rat_(:,4) = [];

%% Creating rating matrix
rat=array2table(test_rat_,'VariableNames',{'userId','movieId','rating'}); % creating a table
ratings=unstack(rat,'rating','userId','VariableNamingRule','preserve');  % creating a pivot table 
ratings=sortrows(ratings,'movieId'); % sorting on based on movie id
ratings=table2array(ratings); % creating the matrix
ratings(:,1)=[];    % removing movie id

%% Finding user mean, movie mean and rating mean
mean_rat=mean(rat.rating);  % mean of all the movies
mean_user=zeros(943,1);
mean_mov=zeros(1682,1);

for i=1:943
    [r,~]=find(rat.userId==i);
    mean_user(i)=mean(rat.(3)(r(1):r(end)));  % mean of all the user
end

for i=1:1682
    mean_mov(i)=mean(ratings(i,:),'omitnan');  % mean of all the movies
end

%% Creating movie table
allData=importdata('u.item','|'); % struct
movieNames=allData.textdata; % contains the movie names with the movie id
movieNames(:,3) = []; % removing the other feilds
movieNames(:,3) = [];
movieNames(:,3) = [];

%% Creating movie table
movie=cell2table(movieNames,'VariableNames',{'movieId','movieName'});  % creating the movie table
movie.movieId=str2double(movie.movieId);
movie.movieName=string(movie.movieName);

%% Creating user info
info=importdata('u.user','|',943); % contains user info

%% Creating user info table
userInfo=cell(943,4);
for i=1:943
    str=split(info(i),'|');
    userInfo(i,1)=str(1);
    userInfo(i,2)=str(2);
    userInfo(i,3)=str(3);
    userInfo(i,4)=str(4);
end
userInfo=array2table(userInfo,'VariableNames',{'userId','Age','Gender','Occupation'});
userInfo.userId=str2double(userInfo.userId);
userInfo.Age=str2double(userInfo.Age);
userInfo.Gender=string(userInfo.Gender);
userInfo.Occupation=string(userInfo.Occupation);

%% Clearing the variables no longer required
clear allData;
clear data_t;
clear movieNames;
clear rat;
clear test_rat_;
clear u1test;
clear info;
clear str;
clear i;
clear r;

%% saving workspace
save('dataset');
