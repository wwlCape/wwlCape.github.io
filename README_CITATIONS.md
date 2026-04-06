# 📊 Google Scholar Citations Auto-Update System

This repository is configured to automatically sync citation counts from Google Scholar and display them on your academic homepage.

## 🎯 Features

- ✅ **Automatic Updates**: GitHub Actions runs daily at 8:00 AM UTC
- ✅ **Real-time Display**: Citation badges update automatically on page load
- ✅ **Google Scholar Sync**: Data sourced directly from your Google Scholar profile
- ✅ **No Manual Maintenance**: Set it and forget it!

## 🔧 How It Works

### 1. Data Collection
- **Python Script** (`scripts/fetch_citations.py`): Uses the `scholarly` library to fetch citation data
- **GitHub Actions** (`.github/workflows/update-citations.yml`): Runs the script daily
- **Data Storage** (`_data/citations.json`): Stores citation counts as JSON

### 2. Display System
- **Dynamic Badges**: Uses Shields.io to display real-time citation counts
- **Badge URL Format**:
  ```
  https://img.shields.io/badge/dynamic/json?
    label=citations
    &query=papers.PAPER_NAME.citations
    &url=https://raw.githubusercontent.com/USERNAME/REPO/main/_data/citations.json
    &color=blue
    &logo=googlescholar
  ```

### 3. Update Schedule
- **Automatic**: Daily at 8:00 AM UTC
- **Manual**: Can be triggered manually via GitHub Actions
- **On Push**: Runs automatically when you push to the main branch

## 📝 Configuration

### Your Google Scholar Profile
- **Profile ID**: `iL2j_yAAAAAJ`
- **Profile URL**: https://scholar.google.com/citations?user=iL2j_yAAAAAJ&hl=en

### Tracked Papers
The system tracks 7 papers:
1. Sonic (CVPR 2025)
2. RealTalk (arXiv 2024)
3. RealSR (CVPR 2020)
4. UniM-OV3D (IJCAI 2024)
5. ColorFormer (ECCV 2022)
6. Spectrum-to-Kernel (NeurIPS 2021)
7. FCA (AAAI 2021)

## 🚀 Setup Instructions

### First Time Setup

1. **Push to GitHub**:
   ```bash
   git add .github/workflows/update-citations.yml
   git add scripts/fetch_citations.py
   git add _data/citations.json
   git add _pages/about.md
   git commit -m "Add Google Scholar auto-update system"
   git push origin main
   ```

2. **Enable GitHub Actions**:
   - Go to your repository on GitHub
   - Click on "Actions" tab
   - Enable workflows if prompted

3. **First Run**:
   - Go to Actions → "Update Google Scholar Citations"
   - Click "Run workflow" → "Run workflow"
   - Wait for completion (takes ~30 seconds)

### Manual Update

To manually trigger an update:
```bash
# Option 1: Via GitHub Web Interface
# Go to Actions → Update Google Scholar Citations → Run workflow

# Option 2: Run locally (requires Python)
pip install scholarly
python scripts/fetch_citations.py
```

## 📂 File Structure

```
├── .github/
│   └── workflows/
│       └── update-citations.yml    # GitHub Actions workflow
├── _data/
│   └── citations.json              # Citation data storage
├── _pages/
│   └── about.md                    # Your homepage (updated badges)
├── scripts/
│   └── fetch_citations.py          # Python script to fetch data
└── README_CITATIONS.md             # This file
```

## 🔍 Adding New Papers

To track a new paper:

1. Edit `scripts/fetch_citations.py`:
   ```python
   PAPERS = {
       "Your Paper Title": "ShortName",
       # Add your new paper here
   }
   ```

2. Add badge to `_pages/about.md`:
   ```markdown
   [![Citations](https://img.shields.io/badge/dynamic/json?label=citations&query=papers.ShortName.citations&url=https://raw.githubusercontent.com/jixiaozhong/acad-homepage.github.io/main/_data/citations.json&color=blue&logo=googlescholar)](https://scholar.google.com/citations?user=iL2j_yAAAAAJ)
   ```

3. Run the update workflow to fetch initial data

## 🐛 Troubleshooting

### Citations not updating?
- Check GitHub Actions logs for errors
- Verify your Google Scholar profile is public
- Make sure paper titles match exactly

### Badge showing "invalid"?
- Check that `citations.json` exists and is properly formatted
- Verify the GitHub raw URL is correct
- Badge may take 5-10 minutes to update due to caching

### Workflow failing?
- Check if `scholarly` library needs updates
- Google Scholar may temporarily block requests (retry after a few hours)
- Check GitHub Actions logs for specific error messages

## 📊 Data Format

The `citations.json` file structure:
```json
{
  "last_updated": "2026-01-23 00:00:00 UTC",
  "total_citations": 253,
  "h_index": 7,
  "i10_index": 5,
  "papers": {
    "Sonic": {
      "title": "Sonic: Shifting focus...",
      "citations": 36,
      "year": "2025",
      "url": "paper_id"
    }
  }
}
```

## 🎨 Customization

### Change Badge Color
Edit the `color` parameter in badge URLs:
- `blue` (default)
- `green` (for new papers)
- `orange`, `red`, etc.

### Change Update Frequency
Edit `.github/workflows/update-citations.yml`:
```yaml
schedule:
  - cron: '0 8 * * *'  # Daily at 8 AM UTC
  # Change to '0 */6 * * *' for every 6 hours
```

## 📚 Resources

- [scholarly Python library](https://github.com/scholarly-python-package/scholarly)
- [Shields.io Documentation](https://shields.io/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Google Scholar](https://scholar.google.com/)

## ⚠️ Important Notes

1. **Google Scholar Rate Limits**: The `scholarly` library uses polite scraping, but Google may temporarily block if overused
2. **GitHub Actions Minutes**: Free tier includes 2000 minutes/month (this uses ~1 minute/day)
3. **Data Accuracy**: Citation counts may lag behind Google Scholar by up to 24 hours
4. **Public Repository Required**: Dynamic badges only work with public repositories

## 📧 Support

If you encounter issues:
1. Check the troubleshooting section above
2. Review GitHub Actions logs
3. Verify your Google Scholar profile settings

---

**Last Updated**: 2026-01-23
**Maintained by**: GitHub Actions (Automated)
