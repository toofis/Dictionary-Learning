clear

%%
%Init
N = 1080*1920;
tr = 15;
folder = 'Lexicons_data\train';
Y = zeros(N,tr);

 for i = 1:tr
      
    cat = sprintf('cat%d.jpg', i);
    I = fullfile(folder, cat);
    I = im2double(rgb2gray(imread(I)));
    Y(:,i) = reshape(I,[N,1]);
 end
 
blocks = N/64;
M = blocks*tr;
K = 256;

Y = reshape(Y,[64,M]);
    for i = 1 : M
        Y(:,i) = Y(:,i)/(norm(Y(:,i)+eps));
    end
    
 D = randn(64,K);
 X = randn(K,M);
 
 for i = 1 : K
     D(:,i) = D(:,i)/norm(D(:,i));
 end
 %%
 %DL
 epochs = 10; err = 10^-7; Thresh = 4;
 msef = zeros(epochs,1);
 for i = 1 : epochs
    for j = 1 : M
        X(:,j) = GenOMP(D,Y(:,j),Thresh,err);
    end
    [D,X] = ksvd(D,X,Y);
    msef(i) = norm((mean(Y-D*X)),'fro')^2;
    i
 end
 figure(1)
 plot(msef)
 
  D_view = [];
  k = 1;
  dim = sqrt(K);
  for i = 1 : dim
     for j = 1 : dim
         D_view((i-1)*8+1:i*8,(j-1)*8+1:j*8) = reshape(D(:,k),[8,8]);
         k = k + 1;
     end
  end
  figure(2)
  imshow(D_view)
  
 %%
 %Testing

tst= 7;
folder = 'Lexicons_data\test';
N_test = 1280*720;

Y_test = zeros(N_test,tst);

 for i = 1 : tst
    %Given testing photos renamed to test1-test7.jpg  
    test = sprintf('test%d.jpg', i);
    I = fullfile(folder, test);
    I = im2double(rgb2gray(imread(I)));
    if i ==1
        Y_test(:,i) = reshape(I(1:720,1:1280),[N_test,1]);
    else
        Y_test(:,i) = reshape(I,[N_test,1]);
    end
 end
blocks = N_test/64;
M = blocks*tst;
K = 256;

Y_test = reshape(Y_test,[64,M]);
X_test = zeros(K,M);

 for i = 1 : M
   Y_test(:,i) = Y_test(:,i)/(norm(Y_test(:,i)+eps));
   X_test(:,i) = GenOMP(D,Y_test(:,i),Thresh,err);
 end
 
mse_rec = zeros(tst,1);
 for i = 1 : tst
    mse_rec(i) = norm(mean(Y(:,(i-1)*blocks + 1 : i*blocks) - D*X(:,(i-1)*blocks + 1 : i*blocks)),'fro')^2;
 end
figure(3)
plot(mse_rec);


 