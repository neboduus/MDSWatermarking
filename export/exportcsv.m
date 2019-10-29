function csv_filename = exportcsv(aI_name, agroupname, wpsnr, attack_log, groupname)

  function extracted_filename = extract_filename(filepath)
    [startIndex, endIndex] = regexp(filepath,'(?:.(?!\/))+$');
    extracted_filename = extractBetween(filepath, startIndex+1, endIndex);
    extracted_filename = extracted_filename{1};
  end
  
  extracted_filename = extract_filename(aI_name);
  attacks = sprintf('%s',cell2mat(attack_log));
  attacks = attacks(1:end-1);% strip final comma
  content = {
  'Image','Group','WPSNR','Attacks with parameters';
  extracted_filename,agroupname,wpsnr,attacks
  };
  csv_filename = strrep(strrep(extracted_filename,'.bmp','.csv'),'.jpg','.csv');
  csv_filename = strcat('export/',csv_filename); %replace /{aIname}.csv
  %edit(csv_filename); %create file if doesn't exist
  writecell(content,csv_filename);
end
