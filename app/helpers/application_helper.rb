module ApplicationHelper
	def board_details(header, report)
		template = %q[<td class='visual-board' style='%s'>%s</td>]

		case header.upcase
		when "LINE"
			return (template % ["width: 10%", "#{report.line.nama}"]).html_safe
		when "OPR"
			return (template % ["", "#{report.detailreports.last.opr}"]).html_safe
		when "TRGT"
			return (template % ["", "#{report.detailreports.last.target}"]).html_safe
		when "TRGT SUM"
			return (template % ["", "#{report.detailreports.sum('target')}"]).html_safe
		when "ACT"
			if report.detailreports.last.detailreportarticles.sum(:output) < report.detailreports.last.target
				return (template % ["", "#{report.detailreports.last.detailreportarticles.sum(:output)}"]).html_safe
			else
				return (template % ["", "#{report.detailreports.last.detailreportarticles.sum(:output)}"]).html_safe
			end
		when "ACT SUM"
			return (template % ["", "#{report.detailreports.joins(:detailreportarticles).sum(:output)}"]).html_safe
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
			return (template % ["line-height:100%; font-size: 24px; width: 30%", "#{report.detailreports.last.remark}"]).html_safe
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
		defects = Defect.where(defect_type: type)

		if type == "Internal"
			head = "INT"
		else
			head = "EXT"
		end

		if data.present?
			data.each{ |k,v| html += "<th>#{head + ' ' + k}</th>" }
			html += "<th>#{head} (SUM)</th>"
		else
			defects.each{ |o| html += "<th>#{head + ' ' + o.name}</th>" }
			html += "<th>#{head} (SUM)</th>"
		end

		html.html_safe
	end

	def show_defect_body(detailreport, type, alternative)
		html = ""
		defects = Defect.where(defect_type: type)

		if type == "Internal"
			data = [detailreport.defect_int, "total_defect_int"]
		else
			data = [detailreport.defect_ext, "total_defect_ext"]
		end

		if JSON.parse(data[0]).present? && alternative.present?
			alternative.each{ |k,v| html += "<td>#{JSON.parse(data[0])[k]}</td>" }
		elsif JSON.parse(data[0]).present?
			JSON.parse(data[0]).each{ |k,v| html += "<td>#{v}</td>" }
		elsif alternative.present?
			alternative.each{ |k,v| html += "<td>0</td>" }
		else
			defects.each{ |o| html += "<td>0</td>" }
		end

		html += "<td>#{Report.send data[1], detailreport.report, detailreport.jam}</td>"
		html.html_safe
	end
end
