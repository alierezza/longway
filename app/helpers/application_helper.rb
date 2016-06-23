module ApplicationHelper
	def board_details(header, report)
		template = %q[<td class='visual-board' style='%s'>%s</td>]

		case header.upcase
		when "LINE"
			return (template % ["", "#{report.line.nama}"]).html_safe
		when "OPR"
			return (template % ["", "#{report.detailreports.last.opr}"]).html_safe
		when "TRGT"
			return (template % ["", "#{report.detailreports.last.target}"]).html_safe
		when "TRGT SUM"
			return (template % ["", "#{report.detailreports.sum('target')}"]).html_safe
		when "ACT"
			if report.detailreports.last.act < report.detailreports.last.target
				return (template % ["", "#{report.detailreports.last.act}"]).html_safe
			else
				return (template % ["", "#{report.detailreports.last.act}"]).html_safe
			end
		when "ACT SUM"
			return (template % ["", "#{report.detailreports.sum('act')}"]).html_safe
		when "%"
			return (template % ["", "#{Report.percent(report, report.detailreports.last.jam)}"]).html_safe
		when "PPH"
			return (template % ["", "#{Report.pph(report, report.detailreports.last.jam)}"]).html_safe
		when "DEFECT"
			return ((template % ["", "#{Report.total_defect_int(report, report.detailreports.last.jam)}"]) +
				   (template % ["", "#{Report.total_defect_ext(report, report.detailreports.last.jam)}"])).html_safe
		when "RFT"
			return (template % ["", "#{Report.rft(report, report.detailreports.last.jam)}"]).html_safe
		when "REMARK"
			return (template % ["line-height:100%; font-size: 24px", "#{report.detailreports.last.remark}"]).html_safe
		when "ARTICLE"
			return (template % ["", "#{report.detailreports.last.detailreportarticles.last.article}"]).html_safe
		when "EFFICIENT"
			return (template % ["", "#{Report.efficiency(report, report.detailreports.last.jam)}"]).html_safe
		end
	end

	def sum_defect_ext(detailreport)
		JSON.parse(detailreport.object.defect_ext.to_s).map{ |k,v| v }.sum
	end

	def sum_defect_int(detailreport)
		JSON.parse(detailreport.object.defect_int.to_s).map{ |k,v| v }.sum
	end

	def show_defect_header(data, type)
		html = ""
		defect = Defect.where(defect_type: type)

		if type == "Internal"
			head = "INT"
		else
			head = "EXT"
		end

		if data.present?
			data.each_with_index do |(key, val), index|
				html += "<th>#{head + ' ' + key}</th>"
				if (index+1) == data.map{ |k,v| k }.length
					html += "<th>#{head} (SUM)</th>"
				end
			end
		else
			defect.each_with_index do |defect, index|
				html += "<th>#{head + ' ' + defect.name}</th>"
				if (index+1) == defect.length
					html += "<th>#{head} (SUM)</th>"
				end
			end
		end

		html.html_safe
	end

	def show_defect_body(detailreport, type, alternative)
		html = ""
		working_state = WorkingDay.find_by_name(detailreport.report.tanggal.strftime("%A")).working_hours.find_by_start(detailreport.jam).working_state
		defect = Defect.where(defect_type: type)

		if type == "Internal"
			data = [detailreport.defect_int, "total_defect_int"]
		else
			data = [detailreport.defect_ext, "total_defect_ext"]
		end

		if JSON.parse(data[0]).present?
			JSON.parse(data[0]).each_with_index do |(key, val), index|
				html += "<td>#{val}</td>"
				if (index+1) == JSON.parse(data[0]).map{ |k,v| k }.length
					html += "<td>#{Report.send data[1], detailreport.report, detailreport.jam}</td>"
				end
			end
		elsif working_state == "Break"
			if alternative.present?
				alternative.each_with_index do |(key, val), index|
					html += "<td>-</td>"
					if (index+1) == alternative.map{ |k,v| k }.length
						html += "<td>-</td>"
					end
				end
			else
				defect.each_with_index do |defect, index|
					html += "<td>-</td>"
					if (index+1) == defect.length
						html += "<td>-</td>"
					end
				end
			end
		elsif alternative.present?
			alternative.each_with_index do |(key, val), index|
				html += "<td>0</td>"
				if (index+1) == alternative.map{ |k,v| k }.length
					html += "<td>#{Report.send data[1], detailreport.report, detailreport.jam}</td>"
				end
			end
		else
			defect.each_with_index do |defect, index|
				html += "<td>#{val}</td>"
				if (index+1) == defect.length
					html += "<td>#{Report.send data[1], detailreport.report, detailreport.jam}</td>"
				end
			end
		end

		html.html_safe
	end
end
