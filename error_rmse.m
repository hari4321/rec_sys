%% RMSE value
cv=cvpartition(size(ratingmatrix,1),'HoldOut',0.3);
idx=cv.test;
dataTrain=data(idx,:);
dataTest=rat_mat(idx,:);

%% avg for test
test_mean_user=zeros(6040,1);
test_mean_mov=zeros(1111,1);
test_sum=0;
test_count=0;

for i=1:1111
    for j=1:6040
        if ~isnan(dataTest(i,j))
            test_sum=test_sum+dataTest(i,j);
            test_count=test_count+1;
        end
    end
end
test_mean_rat=test_sum/test_count;

for i=1:6040
    [r,~]=find(rat.userId==i);
    test_mean_user(i)=mean(rat.(3)(r(1):r(end)));
    
end

for i=1:1111
    test_mean_mov(i)=mean(rat_mat(i,:),'omitnan');
end

%% baseline predictor for test
test_ratingmatrix=zeros(size(dataTest));
for i=1:1111
    for j=1:6040
        if isnan(dataTest(i,j))
            test_ratingmatrix(i,j)=test_mean_rat+(test_mean_rat-test_mean_mov(i))+(test_mean_rat-(test_mean_user(j)));
        end
        if ~isnan(dataTest(i,j))
            test_ratingmatrix(i,j)=dataTest(i,j);
        end
    end
end

%% svd for test
[ut,st,vt]=svd(test_ratingmatrix,'econ');
s3=st;
s3(100:end,:)=0;
s3(:,100:end)=0;
data_pred=ut*s3*vt';

%% Error
err=zeros(1111,1);
for i=1:1111
    for j=1:6040
        err(i)=dataTrain(i,j)-data_pred(i,j);
    end
end
RMSE = sqrt(mean((err).^2));
disp("The RMSE value is "+RMSE);