%% importing the train data
u1base=importdata('u1.base');
u1base(:,4) = [];
data_b=array2table(u1base,'VariableNames',{'userId','movieId','rating'});
dataTrain=unstack(data_b,'rating','userId','VariableNamingRule','preserve');
dataTrain=sortrows(dataTrain,'movieId');
dataTrain=table2array(dataTrain);

%% importing the test data
u1test=importdata('u1.test');
u1test(:,4) = [];
data_t=array2table(u1test,'VariableNames',{'userId','movieId','rating'});
dataTest=unstack(data_t,'rating','userId','VariableNamingRule','preserve');
dataTest=sortrows(dataTest,'movieId');
dataTest=table2array(dataTest);

%% saving movie id of the train and the test data
mid_train=dataTrain(:,1); % movie id of train
mid_test=dataTest(:,1);  % movie id of test
dataTrain(:,1)=[];  % removing the movie id from train
dataTest(:,1)=[];  % removing the movie id from test

%% creating a boolean matrix for finding rmse
bool_test=zeros(size(dataTest));
for i=1:1410
    for j=1:459
        if ~isnan(dataTest(i,j))
            bool_test(i,j)=1;
        end
    end
end

%% Finding the mean values required for baseline prediction
train_sum=0;
train_count=0;

for i=1:1650
    for j=1:943
        if ~isnan(dataTrain(i,j))
            train_sum=train_sum+dataTrain(i,j);
            train_count=train_count+1;
        end
    end
end
mean_rat_train=train_sum/train_count;  % mean of all the movies

mean_user_train=zeros(943,1);
mean_mov_train=zeros(1650,1);

for i=1:943
    [r,~]=find(data_b.userId==i);
    mean_user_train(i)=mean(data_b.(3)(r(1):r(end)));  % mean of all the user
end

for i=1:1650
    mean_mov_train(i)=mean(dataTrain(i,:),'omitnan');  % mean of all the movies
end

%% Baseline prediction
ratingtrain=zeros(size(dataTrain));
for i=1:1650
    for j=1:943
        if isnan(dataTrain(i,j))
            ratingtrain(i,j)=mean_rat_train+(mean_rat_train-mean_mov_train(i))+(mean_rat_train-(mean_user_train(j)));
        end
        if ~isnan(dataTrain(i,j))
            ratingtrain(i,j)=dataTrain(i,j);
        end
    end
end

%% storing the actual and predicted value
actual=zeros(19968,1);
pred=zeros(19968,1);
p=1;
for i=1:1410
    for j=1:459
        if bool_test(i,j)==1
            mt=mid_test(i);
            if ismember(mt,mid_train)
                [k,~]=find(mid_train==mt);
                actual(p)=dataTest(i,j);
                pred(p)=ratingtrain(k,j);
                p=p+1;
            end
        end
    end
end

%% Calculating and displaying the rmse value
RMSE = sqrt(mean((actual-pred).^2));
disp("The RMSE value is "+RMSE);
