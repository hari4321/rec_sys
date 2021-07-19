%% loading the data
load('dataset.mat');

%% predicting the rating
ratingmatrix=zeros(size(ratings));
for i=1:1682
    for j=1:943
        if isnan(ratings(i,j))
            ratingmatrix(i,j)=mean_rat+(mean_rat-mean_mov(i))+(mean_rat-(mean_user(j))); % the baseline predictor formaula
        end
        if ~isnan(ratings(i,j))
            ratingmatrix(i,j)=ratings(i,j); % taking the same rating
        end
    end
end

%% svd
[u,s,v]=svd(ratingmatrix);
s2=s;
s2(100:end,:)=0;
s2(:,100:end)=0;
data=u*s2*v';

%% Entering the movie name
mn=input("Enter movie name: ",'s');
m=movie.movieId(find(strcmp(movie.movieName,mn)),1);
% Toy Story (1995)

%% calculates the cos of the angle
x=data(m,:);  % contains the data of the selected movie
cosine=zeros(1682,1);
for i=1:1682
    y=data(i,:);  % contains the data of all the movie
    cosine(i) = (dot(x,y))/(norm(x)*norm(y)); % formula for cos of the angle
end

%% Finding top movieId
top=maxk(cosine,11); % to get the top values
disp(" ");
disp("The recommendations for "+movie.movieName(find(movie.movieId==m),1)+":");
for k=2:11
    [w, ~] = find(cosine == top(k));  
    name=movie.movieName(find(movie.movieId==w),1);  % finding the name of the movie
    disp(name);  % displaying the name
end
