x = (0:1e-2:3)';
g = lognpdf(x,log(0.175),1.2);
i = wblpdf(x,.7,2.2);
plot(x,g,x,i,'-.');
xlabel('Matching score');
ylabel('Frequency (%)');
legend('Genuine','Impostor');