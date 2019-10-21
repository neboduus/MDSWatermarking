function csv_filename = exportcsv(aI_name, agroupname, wpsnr, attack_log, groupname)

  function extracted_filename = extract_filename(filepath)
    [startIndex, endIndex] = regexp(aI_name,'(?:.(?!\/))+$');
    extracted_filename = extractBetween(aI_name, startIndex+1, endIndex);
  end

  extracted_filename = extract_filename(aI_name);
  attacks = sprintf('%s',cell2mat(attack_log));
  attacks = attacks(1:end-1);% strip final comma
  content = {
  'Image','Group','WPSNR','Attacks with parameters';
  extracted_filename,agroupname,wpsnr,attacks
  }; %csv header

  csv_filename = strcat('export/',strrep(extracted_filename,'.bmp','.csv')); %replace /{aIname}.csv
  %edit(csv_filename); %create file if doesn't exist
  writecell(content,csv_filename);
end
