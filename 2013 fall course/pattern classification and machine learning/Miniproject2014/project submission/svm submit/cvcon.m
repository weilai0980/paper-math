function [td, vd,tl,vl]= cvcon(data,label,cvn,cvcnt)

n=size(data);
tdcnt=1;
vdcnt=1;

  n;
  cvn;
  cvcnt;
  
  vd(1:cvn,:)=data(cvn*cvcnt+1:cvn*(cvcnt+1),:);
  vl(1:cvn,:)=label(cvn*cvcnt+1:cvn*(cvcnt+1),:);
  
  if cvcnt==0
  td(1:n-cvn,:)=data(cvn+1:n,:);
  tl(1:n-cvn,:)=label(cvn+1:n,:);   
  elseif cvcnt==9
  td(1:n-cvn,:)=data(1:n-cvn,:);
  tl(1:n-cvn,:)=label(1:n-cvn,:);
  else
      td(1:cvn*(cvcnt),:)=data(1:cvn*(cvcnt),:);     
      td(cvn*(cvcnt)+1:n-cvn,:)=data(cvn*(cvcnt+1)+1:n,:); 
      
      tl(1:cvn*(cvcnt),:)=label(1:cvn*(cvcnt),:);     
      tl(cvn*(cvcnt)+1:n-cvn,:)=label(cvn*(cvcnt+1)+1:n,:); 
  end
  
%for i=1:n
%if i> cvn*cvcnt && i <= cvn*(cvcnt+1)
 %   vd(vdcnt,:)=data(i,:);
 %   vl(vdcnt,:)=label(i,:);
 %   vdcnt=vdcnt+1;
%else
%    td(tdcnt,:)=data(i,:);
 %   tl(tdcnt,:)=label(i,:);
  %  tdcnt=tdcnt+1;
%end

%end

