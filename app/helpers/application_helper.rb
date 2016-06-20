module ApplicationHelper
	def board_details(header, report)
		template = %q[<td style='%s'><b><font size='%s'>%s</font></b></td>]

		case header.upcase
		when "LINE"
			return (template % ["", "6", "L. #{report.line.no}"]).html_safe
		when "OPR"
			return (template % ["", "6", "#{report.detailreports.last.opr}"]).html_safe
		when "TARGET"
			return (template % ["", "6", "#{report.detailreports.last.target}"]).html_safe
		when "TARGET SUM"
			return (template % ["", "6", "#{report.detailreports.sum('target')}"]).html_safe
		when "ACT"
			if report.detailreports.last.act < report.detailreports.last.target
				return (template % ["", "6", "#{report.detailreports.last.act}"]).html_safe
			else
				return (template % ["", "6", "#{report.detailreports.last.act}"]).html_safe
			end
		when "ACT SUM"
			return (template % ["", "6", "#{report.detailreports.sum('act')}"]).html_safe
		when "%"
			return (template % ["", "6", "#{Report.percent(report, report.detailreports.last.jam)}"]).html_safe
		when "PPH"
			return (template % ["", "6", "#{Report.pph(report, report.detailreports.last.jam)}"]).html_safe
		when "DEFECT"
			return ((template % ["", "6", "#{Report.total_defect_int(report, report.detailreports.last.jam)}"]) +
				   (template % ["", "6", "#{Report.total_defect_ext(report, report.detailreports.last.jam)}"])).html_safe
		when "RFT"
			return (template % ["", "6", "#{Report.rft(report, report.detailreports.last.jam)}"]).html_safe
		when "REMARK"
			return (template % ["line-height:60%", "3", "#{report.detailreports.last.remark}"]).html_safe
		when "ARTICLE"
			return (template % ["line-height:60%", "3", "#{report.detailreports.last.detailreportarticles.last.article}"]).html_safe
		when "EFFICIENT"
			return (template % ["", "6", "#{Report.efficiency(report, report.detailreports.last.jam)}"]).html_safe
		end
	end
end
