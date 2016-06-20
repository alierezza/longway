module ApplicationHelper
	def board_details(header, report)
		case header.upcase
		when "LINE"
			return "<td><b><font size='6'>L. #{report.line.no}</font></b></td>".html_safe
		when "OPR"
			return "<td><b><font size='6'>#{report.detailreports.last.opr}</font></b></td>".html_safe
		when "TARGET"
			return "<td><b><font size='6'>#{report.detailreports.last.target}</font></b></td>".html_safe
		when "TARGET SUM"
			return "<td><b><font size='6'>#{report.detailreports.sum('target')}</font></b></td>".html_safe
		when "ACT"
			if report.detailreports.last.act < report.detailreports.last.target
				return "<td><b><font size='6' color=red>#{report.detailreports.last.act}</font></b></td>".html_safe
			else
				return "<td><b><font size='6'>#{report.detailreports.last.act}</font></b></td>".html_safe
			end
		when "ACT SUM"
			return "<td><b><font size='6'>#{report.detailreports.sum('act')}</font></b></td>".html_safe
		when "%"
			return "<td><b><font size='6'>#{Report.percent(report, report.detailreports.last.jam)}</font></b></td>".html_safe
		when "PPH"
			return "<td><b><font size='6'>#{Report.pph(report, report.detailreports.last.jam)}</font></b></td>".html_safe
		when "DEFECT"
			return "<td><b><font size='6'>#{Report.total_defect_int(report, report.detailreports.last.jam)}</font></b></td>
					<td><b><font size='6'>#{Report.total_defect_ext(report, report.detailreports.last.jam)}</font></b></td>".html_safe
		when "RFT"
			return "<td><b><font size='6'>#{Report.rft(report, report.detailreports.last.jam)}</font></b></td>".html_safe
		when "REMARK"
			return "<td style='line-height:60%'><b><font size='3'>#{report.detailreports.last.remark}</font></b></td>".html_safe
		when "ARTICLE"
			return "<td style='line-height:60%'><b><font size='3'>#{report.detailreports.last.detailreportarticles.last.article}</font></b></td>".html_safe
		when "EFFICIENT"
			return "<td><b><font size='6'>#{Report.efficiency(report, report.detailreports.last.jam)}</font></b></td>".html_safe
		end
	end
end
