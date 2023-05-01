%% Read and process file
T = readtable('the_dataset.xlsx');
T.breed_vc = categorical(T.breed_vc);
%%
breed_match = "Labrador Retriever";
%breed_match = "Pug";
breedidx = T.breed_vc == breed_match;
vars = {'lifespan'};
breed = T(breedidx, vars);
breed = table2array(breed(:,1));
%%
% [h,stats] = cdfplot(bulldogs)
% distributionFitter(bulldogs)

t = linspace(min(breed),max(breed));

% Weibull
parmWblHat = wblfit(breed); % Weibull parameter estimatescollapse
a = parmWblHat(:,1);
b = parmWblHat(:,2);

% Gamma
parmGamHat = gamfit(breed); % Weibull parameter estimatescollapse
c = parmGamHat(:,1);
d = parmGamHat(:,2);

% Log-normal
parmLogGamHat = lognfit(breed); % Weibull parameter estimatescollapse
e = parmLogGamHat(:,1);
f = parmLogGamHat(:,2);

% Log-Logi
parmLogLogiHat = fitdist(breed,"Loglogistic")
g = 1.87661 %parmLogLogiHat(:,1);
h = 0.577976 %parmLogLogiHat(:,2);

% Burr
% parmBurrHat = fitdist(breed,'burr');
% g = parmBurrHat(:,1);
% h = parmBurrHat(:,2);
% i = parmBurrHat(:,3);

%% Empirical vs Theorical
% stats
ecdf(breed) % empirical
hold on
plot(t,wblcdf(t,a,b))
plot(t,gamcdf(t,c,d))
plot(t,logncdf(t,e,f))
plot(t,cdf('LogLogistic',breed,g,h))

% QRScdf=cdf('burr',sortrows(breed),g,h,i);
% plot(sortrows(breed),QRScdf)


legend('Empirical CDF','Theoretical Weibull CDF','Theoretical Gamma CDF', ...
    'Theoretical Lognormal CDF','Theoretical Loglogi CDF','Location','best')
hold off
%% Hypothesis Test
test_cdf = makedist('Weibull','A', a,'B', b);
[h_wbl, p_wbl] = kstest(breed,'CDF',test_cdf); %,'Alpha',0.01)
% The returned value of h = 1 indicates that kstest rejects the null hypothesis at the default 5% significance level.
test_cdf = makedist('Gamma','a', c,'b', d);
[h_gam, p_gam] = kstest(breed,'CDF',test_cdf);
test_cdf = makedist('Lognormal','mu', e,'sigma', f);
[h_logn, p_logn] = kstest(breed,'CDF',test_cdf);
test_cdf = makedist('Loglogistic','mu', g,'sigma', h);
[h_loglogi, p_loglogi] = kstest(breed,'CDF',test_cdf)

if h_wbl == 0
    fprintf('No rechaza hipotesis de que es una Weibull\n');
else
    fprintf('Rechaza hipotesis de que es una Weibull\n');
end
if h_gam == 0
    fprintf('No rechaza hipotesis de que es una Gamma\n');
else
    fprintf('Rechaza hipotesis de que es una Gamma\n');
end
if h_logn == 0
    fprintf('No rechaza hipotesis de que es una Lognormal\n');
else
    fprintf('Rechaza hipotesis de que es una Lognormal\n');
end
if h_loglogi == 0
    fprintf('No rechaza hipotesis de que es una Loglogi\n');
else
    fprintf('Rechaza hipotesis de que es una Loglogi\n');
end

%% Hazard rate
% Compute the hazard function for the Weibull distribution with the scale parameter value a and the shape parameter value b.
h1 = wblpdf(t,a,b)./(1-wblcdf(t,a,b));

plot(t,h1,'-')
xlabel('Observation')
ylabel('Hazard Rate')
legend('Weibull','location','northwest')

%%
fitdist(breed, "gamma")