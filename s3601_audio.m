clear all
load sample1.txt
A = reshape(sample1,[2, 480000]);
B = A(1,:)';
% for i = 1:length(B)-2
%     if (B(i)/B(i+1) > 1.9 && B(i+2)/B(i+1) > 1.9)
%         B(i+1) = B(i+1)*2;
%     end
%     if B(i) < 230632
%         B(i) = 230632;
%     end
% end
% B = B - 246632;
% B = movmean(B,17);
%B = B(130000:345000);
p = audioplayer(B, 48000);
plot(B)
play(p)
% filename = 'handel.wav';
% audiowrite(filename, B, 48000);