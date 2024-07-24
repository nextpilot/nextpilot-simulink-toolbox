% % function main
px4root = 'E:\repository\px4\pixhawk';


%% 提取所有的sub和pub
cd([px4root,'\src\modules'])
[~,txt]=dos('dir /b/ad');
modules = textscan(txt,'%s');
modules= modules{1};
mod_sub_pub=struct;
for i=1:length(modules)
    cd([px4root,'\src\modules\',modules{i}])
    sub={};pub={};
    [flg,txt] = dos(['dir /b/s *.c *.cpp']);
    if flg ~= 0
        continue
    end
    files = textscan(txt,'%s');
    files = files{1};
    for j = 1:length(files)
        fid=fopen(files{j});
        txt=fscanf(fid,'%c');
        fclose(fid);
        pub_t=regexpi(txt,'orb_publish\w*\(([^,]+)','tokens');
        sub_t=regexpi(txt,'orb_subscribe\w*\(([^)]+)','tokens');
        pub=[pub pub_t{:}];
        sub=[sub sub_t{:}];
    end
    pub =unique(replace(pub,{'ORB_ID(',')'},{'',''}));
    sub =unique(replace(sub,{'ORB_ID(',')'},{'',''}));
    mod_sub_pub.(modules{i}).pub=pub;
    mod_sub_pub.(modules{i}).sub=sub;
end
mod_sub_pub=orderfields(mod_sub_pub);
%% 将sub和pub进行统计
msg_sub_pub=struct;
for i=1:length(modules)
    for j =1:length(mod_sub_pub.(modules{i}).pub)
        pub=mod_sub_pub.(modules{i}).pub{j};
        if ~isvarname(pub)
            pub=genvarname(['xyz_',pub]);
        end
        if isfield(msg_sub_pub,pub) && isfield(msg_sub_pub.(pub),'pub')
            msg_sub_pub.(pub).pub=[msg_sub_pub.(pub).pub,modules{i}];
        else
            msg_sub_pub.(pub).pub={modules{i}};
        end
    end
    for j =1:length(mod_sub_pub.(modules{i}).sub)
        sub=mod_sub_pub.(modules{i}).sub{j};
        if ~isvarname(sub)
            sub=genvarname(['xyz_',sub]);
        end
        if  isfield(msg_sub_pub,sub) && isfield(msg_sub_pub.(sub),'sub')
            msg_sub_pub.(sub).sub=[msg_sub_pub.(sub).sub,modules{i}];
        else
            msg_sub_pub.(sub).sub={modules{i}};
        end
    end
    
end
msg_sub_pub=orderfields(msg_sub_pub);
return

%% 输出到word文档
import mlreportgen.dom.*;
root = Document('today','docx'); % mywordTemplate
root.StreamOutput = true;
root.append(TOC);

% 模块订阅和发布的主题
% 标题
root.append(Heading1('模块订阅和发布的主题'));
p = Paragraph('下标列出了所有模块订阅和发布的主题');
root.append(p);
% 表格内容
header={'模块','订阅','发布'};
field=fieldnames(mod_sub_pub);
body={};
rf=sprintf('\n');
for i=1:length(field)
    try
        sub=mod_sub_pub.(field{i}).sub;
    catch
        sub={};
    end
    if isempty(sub)
        sub={''};
    else
        sub=join(sub,rf);
    end
    try
        pub=mod_sub_pub.(field{i}).pub;
    catch
        pub={};
    end
    if isempty(pub)
        pub={''};
    else
        pub=join(pub,rf);
    end
    body(i,:)={field{i},sub{:},pub{:}};
end
t=FormalTable ({'主题','订阅','发布'},body);
t.Border = 'single';
root.append(t);

% 主题的发布和订阅模块
% 标题
root.append(Heading1('主题订阅和发布的模块'));
p = Paragraph('下标列出了所有主题订阅和发布的模块');
root.append(p);
% 表格
header={'主题','订阅','发布'};
field=fieldnames(msg_sub_pub);
body={};
rf=sprintf('\n');
for i=1:length(field)
    try
        sub=msg_sub_pub.(field{i}).sub;
    catch
        sub={};
    end
    if isempty(sub)
        sub={''};
    else
        sub=join(sub,rf);
    end
    try
        pub=msg_sub_pub.(field{i}).pub;
    catch
        pub={};
    end
    if isempty(pub)
        pub={''};
    else
        pub=join(pub,rf);
    end
    body(i,:)={field{i},sub{:},pub{:}};
end
t=FormalTable ({'主题','订阅','发布'},body);
t.Border = 'single';
root.append(t);
%

close(root);
rptview(root.OutputPath);

