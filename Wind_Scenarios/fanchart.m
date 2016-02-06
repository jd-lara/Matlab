function [] = fanchart(quant)
%FanChart Generation for the Fancharts 
figure
quant1=quant';
quant2=quant';
for i=2:size(quant1,2)
    quant1(:,i)=quant1(:,i)-quant2(:,i-1);
end
h=area(quant1);
set(h,'LineStyle','none'); r1=.4; g=0;
set(h(1),'FaceColor',[1 1 1]) % white
set(h(2),'FaceColor',[r1 g .99])
set(h(3),'FaceColor',[r1 g .875])
set(h(4),'FaceColor',[r1 g .75])
set(h(5),'FaceColor',[r1 g .6])
set(h(6),'FaceColor',[r1 g .55])
set(h(7),'FaceColor',[r1 g .4])
set(h(8),'FaceColor',[r1 g .35])
set(h(9),'FaceColor',[r1*0.8 g .22])
set(h(10),'FaceColor',[r1*0.75 g .1]) %
set(h(11),'FaceColor',[r1*0.75  g .1])%
set(h(12),'FaceColor',[r1*0.8 g .22])
set(h(13),'FaceColor',[r1 g .35])
set(h(14),'FaceColor',[r1 g .4])
set(h(15),'FaceColor',[r1 g .55])
set(h(16),'FaceColor',[r1 g .6])
set(h(17),'FaceColor',[r1 g .75])
set(h(18),'FaceColor',[r1 g .875])
set(h(19),'FaceColor',[r1 g .99])
hold on
plot(quant(10,:),'-r');  % median forecast in black

end

