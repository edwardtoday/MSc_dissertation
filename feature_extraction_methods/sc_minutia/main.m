%
%    Author: Joshua Abraham
%    Email: algorithm007@hotmail.com
%    Description: Main script to perform FVC2002 matching experiment
%


cd  '/home/joshua/Research/FVC2002/Dbs/Db1_a'
%cd  '/home/joshua/FVS_DB'

files = dir(  '/home/joshua/Research/FVC2002/Dbs/Db1_a/*.tif');
%files = dir(  '/home/joshua/FVS_DB/*_*.bmp');

file_names = {files.name};

o_start = 0;

if numel(BASE_IMG) ~= 0
 for i = 1:numel(file_names)

   if numel(char(file_names(i)))  ~= size(BASE_IMG)                                                     
     continue
   end       
   if(char(file_names(i)) == BASE_IMG)
     o_start = i;
     break;
   end
 end 
 
 i_start = o_start + 1;

 for i = o_start + 1:numel(file_names)
   if numel(char(file_names(i)))  ~= size(COMP_IMG)
      continue
   end
   if(char(file_names(i)) == COMP_IMG)
     i_start = i;
     break;
   end
 end 
else
  o_start = 1;
  i_start = 2;
end  

if i_start == o_start + 1 && o_start == 1
  RES_G = [];
  RES_B = [];
  VG=[];
  VB=[]; 
  SC_G=[];
  SC_B=[];
  same_flag = 0;
  fnmc = 0;
  fmc = 0;
  tmc = 0;
  tnmc = 0;
  disp('Starting from beginning');
  avg_fnm_err = 0;
  avg_tnm_err = 0;
  avg_tm_err = 0;
  avg_fm_err = 0;
end

error_boundary = 0.5;

for index1 = o_start: (numel(file_names))
  file_a = file_names(index1);
  BASE_IMG = char(file_a);
  for index2 = i_start:numel(file_names) 
       COMP_IMG =  char(file_names(index2))  ;
       if numel(COMP_IMG) == numel(BASE_IMG) & (substring(COMP_IMG, 0, numel(COMP_IMG) - 6) == substring(BASE_IMG,0, numel(BASE_IMG) - 6)) 
         same_flag = 1;
       else 
         same_flag = 0;
         if mod(index1, 8) ~= 1 || mod(index2, 8) ~=1
            same_flag = -1;
         end
       end
      if same_flag > -1
        disp(['Comparing ' char(file_names(index1)) ' with ' char(file_names(index2)) ' same_flag = ' num2str(same_flag)])
        [res, vv, sc] =do_match(char(file_names(index1)), char(file_names(index2)));

      end

      if res < error_boundary && same_flag==1 
	 disp(['Bad Genuine'])
         disp([' ' char(file_names(index1)) ' with ' char(file_names(index2)) ' same_flag = ' num2str(same_flag)])
	% pause
      end

      if res > error_boundary && same_flag==0 
	 disp(['Bad Impostor'])
         disp([' ' char(file_names(index1)) ' with ' char(file_names(index2)) ' same_flag = ' num2str(same_flag)])
	% pause
      end


      if same_flag == 1
        RES_G = [RES_G res];      
        VG = [VG vv];
        SC_G = [SC_G sc];
        if res > error_boundary
          tmc = tmc + 1;
          avg_tm_err = (avg_tm_err*(tmc-1) + res)/tmc ;  
        else
          fnmc = fnmc + 1;
          avg_fnm_err = (avg_fnm_err*(fnmc-1) + res)/fnmc;
        end
      elseif same_flag == 0

        RES_B = [RES_B res];
        SC_B = [SC_B sc];
        VB = [VB vv];

        if res <= error_boundary
          tnmc = tnmc + 1;
          avg_tnm_err = (avg_tnm_err*(tnmc-1) + res)/tnmc;
        else 
         fmc = fmc + 1;
         avg_fm_err = (avg_fm_err*(fmc-1) + res)/fmc;
        end
      end
      COMP_IMG =  char(file_names(index2)); 
  end
  cla
  i_start = index1 + 2;
  [ig,ib]=calc_EER(1./(RES_G-0.3*SC_G+0.5),  1./(RES_B-0.3*SC_B+0.5)); hold on ; plot(ig,'b'); plot(ib,'r');hold off;
  axis([1040 1060 0.4 0.8]); 
  xlabel('threshold (t)')  
  ylabel('EER (%)')
  drawnow
end

