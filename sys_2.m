%% Importing ratings.dat
rat=ratings("ratings.dat", [1, Inf]); 

%% Importing movies.dat
mov=movies("movies.dat", [1, Inf]); 

%% Creating a rating table corresponding to the matrix
rating=unstack(rat,'ratings','movieId','VariableNamingRule','preserve');

%% movieId matrix and ratingmatrix
rating(:,1) = [];
rating=rows2vars(rating);
m_id_matrix=rating(:,1);
m_id_matrix=str2double(m_id_matrix{:,:});
rating(:,1) = [];
rat_mat=table2array(rating);

%% avg
mean_rat=mean(rat.ratings);
mean_user=zeros(6040,1);
mean_mov=zeros(3706,1);

for i=1:6040
    [r,~]=find(rat.userId==i);
    mean_user(i)=mean(rat.(3)(r(1):r(end)));
    
end

for i=1:3706
    mean_mov(i)=mean(rat_mat(i,:),'omitnan');
end

%% baseline predictor
ratingmatrix=zeros(size(rat_mat));
for i=1:3706
    for j=1:6040
        if isnan(rat_mat(i,j))
            ratingmatrix(i,j)=mean_rat+(mean_rat-mean_mov(i))+(mean_rat-(mean_user(j)));
        end
        if ~isnan(rat_mat(i,j))
            ratingmatrix(i,j)=rat_mat(i,j);
        end
    end
end

%% svd
[u,s,v]=svd(ratingmatrix,'econ');
s2=s;
s2(100:end,:)=0;
s2(:,100:end)=0;
data=u*s2*v';

%% cosine distance
mn=input("Enter movie name: ",'s');
m=mov.movieId(find(mov.movieName==mn),1);
x=data(m,:); 
cosdistance=zeros(3706,1);
for i=1:3706
    y=data(i,:);
    cs_num=sum(x.*y);
    cs_den=sqrt(sum(x.*x))*sqrt(sum(y.*y));
    cosdistance(i)=cs_num/cs_den;
end

%% Finding top movieId
extra=[m_id_matrix,cosdistance];
top=maxk(cosdistance,10);
r=zeros(10,1);
c=zeros(10,1);
m_id=zeros(10,1);
disp(" ");
disp("The recommendations for "+mov.movieName(find(mov.movieId==m),1)+":");
for k=1:10
    [r(k), c(k)] = find(cosdistance == top(k));
    m_id(k)=extra(r(k), c(1));
    name=mov.movieName(find(mov.movieId==m_id(k)),1);
    disp(name);
end
